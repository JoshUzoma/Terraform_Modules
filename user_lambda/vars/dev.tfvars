organization = "josh"
team         = "sp"
env          = "dev"
aws_region   = "us-east-2"


lambda_artifact_bucket = "josh-dev-lambda-artifacts"  # S3 bucket where CI/CD stores Lambda & layer zips

lambda_functions = {
   digest_index = {
    purpose      = "indexing"
    handler      = "index.handler"
    runtime      = "python3.9"
    role_arn     = "arn:aws:iam::051826731160:role/josh-sp-iam-etl-dev"
    environment_variables = {
      STAGE = "dev"
    }
    s3_key            = "lambdas/digest_index.zip"
    #source_code_hash  = "REPLACE BY CICD"
    create_layer      = true
    layer_s3_key      = "layers/digest_index.zip"
    layers            = []
    s3_event          = null
  }
my_new_lambda = {
    purpose      = "new_lambda"
    handler      = "new.handler"
    runtime      = "python3.9"
    role_arn     = "arn:aws:iam::051826731160:role/josh-sp-iam-etl-dev"
    environment_variables = {
      STAGE = "dev"
    }
    s3_key            = "lambdas/my_new_lambda.zip"
    #source_code_hash  = "REPLACE BY CICD"
    create_layer      = false
    layers            = [
      "arn:aws:lambda:us-east-2:336392948345:layer:AWSSDKPandas-Python39:30" ]
    s3_event          = null
  }
hello_world = {
    purpose      = "hello"
    handler      = "new.handler"
    runtime      = "python3.9"
    role_arn     = "arn:aws:iam::051826731160:role/josh-sp-iam-etl-dev"
    environment_variables = {
      STAGE = "dev"
    }
    s3_key            = "lambdas/hello_world.zip"
    #source_code_hash  = "REPLACE BY CICD"
    create_layer      = false
    layers            = [
      "arn:aws:lambda:us-east-2:336392948345:layer:AWSSDKPandas-Python39:30" ]
    s3_event          = null
  }

Salesforce = {
    purpose      = "Sales"
    handler      = "new.handler"
    runtime      = "python3.9"
    role_arn     = "arn:aws:iam::051826731160:role/josh-sp-iam-etl-dev"
    environment_variables = {
      STAGE = "dev"
    }
    s3_key            = "lambdas/Salesforce.zip"
    #source_code_hash  = "REPLACE BY CICD"
    create_layer      = false
    layers            = [
      "arn:aws:lambda:us-east-2:336392948345:layer:AWSSDKPandas-Python39:30" ]
    s3_event          = null
  }
}
