def lambda_handler(event, context):
    """
    Basic Lambda function for testing CI/CD pipeline.
    Simply returns a greeting and echoes back the input event.
    """
    return {
        "statusCode": 200,
        "body": f"Hello from Lambda! You sent: {event}"
    }