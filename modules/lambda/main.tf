resource "aws_lambda_function" "this" {
  function_name    = local.lambda_name
  handler          = var.handler
  runtime          = var.runtime
  role             = var.role_arn
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  layers = (
  var.create_layer ?
  [aws_lambda_layer_version.this[0].arn] :
  var.layers
)

  environment {
    variables = var.environment_variables
  }
  
  tags = local.all_tags
}

resource "aws_lambda_layer_version" "this" {
  count = var.create_layer ? 1 : 0
  filename             = var.layer_zip
  layer_name           = "${var.organization}-${var.team}-layer-${var.purpose}-${var.env}"
  compatible_runtimes  = [var.runtime]
}