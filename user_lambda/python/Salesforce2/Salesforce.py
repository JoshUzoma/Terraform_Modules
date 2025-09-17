import json
import boto3
import pandas as pd
import io
from io import StringIO
import time
import os
import random
import plivo
from datetime import datetime, timezone
from botocore.exceptions import ClientError


def get_secret():

    secret_name = "BB/plivio" # nosec
    region_name = "us-east-2"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    secret = get_secret_value_response['SecretString']
    return json.loads(secret) 

def lambda_handler(event, context):

    client = boto3.client('logs')
    s3_client = boto3.client('s3')

    response = client.describe_log_streams(
        logGroupName='/aws/lambda/salesforce-eventbridge-test',
        orderBy='LastEventTime',
        descending=True,
        limit=1
    )

    temp_log = response['logStreams']
    #print(response['logStreams'])
    #print(temp_log[0]['logStreamName'])

    response = client.get_log_events(
        logGroupName='/aws/lambda/salesforce-eventbridge-test',
        #logGroupIdentifier='arn:aws:logs:us-east-2:051826731160:log-group:/aws/lambda/salesforce-eventbridge-test:*',
        logStreamName=temp_log[0]['logStreamName']
    )
    
    #print(response)
    temp = response['events']
    res = json.loads(temp[0]['message'])
    res_detail = res['detail']

    print(res_detail['LastModifiedDate'])
    dt = datetime.strptime(res_detail['LastModifiedDate'], "%Y-%m-%dT%H:%M:%S.%fZ")
    dt = dt.replace(tzinfo=timezone.utc)

    formatted = dt.strftime("%Y-%m-%d %H:%M:%S%z")
    # Insert colon in timezone offset for ISO 8601 compliance
    formatted = formatted[:-2] + ":" + formatted[-2:]
    print(formatted)
    if (('Status' in res_detail) & (res_detail['Status'] == 'Escalated')):
        print(True)
        #print(res_detail['Status'])
                #kick-off the flow to grab case data (filtered by id?)
        appflow_client = boto3.client('appflow')
        appflow_response = appflow_client.start_flow(
            flowName='SF-Connection-Flow'
        )   
        #print(appflow_response)
        print(appflow_response['executionId'])
        
        #sleep to allow appflow to finish running before grabbing results
        time.sleep(15)
        
        #grab the flow output
        flow_file = appflow_response['executionId']
        Prefix= "amazon-appflow-tests/salesforce-data-pull/SF-Connection-Flow/" + flow_file + "/"
        #print(Prefix)
#
        #list the files in the appflow response
        response = s3_client.list_objects_v2(
            Bucket='dea-diversions-data',
            Prefix= "amazon-appflow-tests/salesforce-data-pull/SF-Connection-Flow/" + flow_file + "/")
        files = response.get("Contents")
        for file in files:
            print(f"file_name: {file['Key']}, size: {file['Size']}")
            appflow_file = file['Key']

        response = s3_client.get_object(Bucket = 'dea-diversions-data', Key = appflow_file)
        appflow_file = pd.read_csv(response['Body']).sort_values('LastModifiedDate')
        appflow_file['LastModifiedDate'] = appflow_file['LastModifiedDate'].astype(str)
        
        appflow_file["LastModifiedDate"] = pd.to_datetime(appflow_file["LastModifiedDate"], format="%Y-%m-%dT%H:%M:%S.%f%z")
        print(appflow_file['LastModifiedDate'])

        record = appflow_file[appflow_file['LastModifiedDate']==formatted].reset_index(drop=True)
        print(record.iloc[0]['CaseNumber'])
        case_number = record.iloc[0]['CaseNumber']


        #from here you would send the sms message on the case
        db_secret = get_secret()
        client_id = db_secret['client_id'] 
        client_secret = db_secret['client_secret']
        client_p = plivo.RestClient(client_id, client_secret)
        response = client_p.messages.create(
            src="+1 844-532-7156",
            dst="+1 443-253-8566",
            text=f"Salesforce Case Number: {case_number} requires supervisor intervention. Please review accordingly."
            )

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }