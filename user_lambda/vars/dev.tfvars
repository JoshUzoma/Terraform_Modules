organization = "josh"
team         = "sp"
env          = "dev"
aws_region   = "us-east-2"

lambda_functions = {
  etl_transform = {
    purpose      = "transform"
    handler      = "etl.handler"
    runtime      = "python3.9"
    filename     = "build/test_lambda.zip"
    role_arn     = "arn:aws:iam::051826731160:role/josh-sp-iam-etl-dev"
    environment_variables = {
      STAGE = "dev"
    }
    # Test Layer creation
    create_layer = true
    layer_zip    = "build/common_layer.zip"  # path to zipped layer
    
    #Attach additional layers if needed
    layers = []

  }
}