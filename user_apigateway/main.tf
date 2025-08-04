module "api_gateway" {
  source = "../modules/api_gateway"
  stage_name  = var.stage_name
  cors_config = var.cors_config

  routes = [
    {
      path       = "/hello"
      method     = "GET"
      lambda_arn = "arn:aws:lambda:us-east-2:051826731160:function:josh-sp-lambda-transform-dev"
    },
    {
      path       = "/goodbye"
      method     = "POST"
      lambda_arn = "arn:aws:lambda:us-east-2:051826731160:function:bb-apigateway-bbapigatewayfunction62AE1AB4-nAn8Ib9IH5VIce"
    }
  ]

  authorizer_config = {
    type             = "JWT"
    identity_sources = ["$request.header.Authorization"]
    audience         = ["2vn43l6b67vdmtmg2pp7igpmf2"]
    issuer           = "https://cognito-idp.us-east-2.amazonaws.com/us-east-2_e2vHDSO9r"
  }

  logging_config = {
    destination_arn = "arn:aws:logs:us-east-2:051826731160:log-group:/aws/apigateway/SINATRA-api-test:*"
    format          = "{\"requestId\":\"$context.requestId\",\"status\":\"$context.status\"}"
    logging_level   = "INFO"
  }

  organization   = var.organization
  team           = var.team
  aws_region     = var.aws_region
  resource_type  = var.resource_type
  purpose        = var.purpose
  env            = var.env
}






