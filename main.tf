terraform {
  backend "s3" {
    bucket  = "s3-terraform-state-backend"
    region  = "eu-central-1"
    key     = "jester-lambda-function/terraform.tfstate"
  }
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region      = "eu-central-1"
  access_key  = "${var.aws_access_key_id}"
  secret_key  = "${var.aws_secret_access_key}"
}

resource "aws_iam_role" "iam_for_lambda_jester" {
  name                = "iam_for_lambda_jester"
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_function" "jester" {
  filename      = "build/libs/jester-lambda-function-1.0.jar"
  function_name = "jester_lambda_function"
  role          = "${aws_iam_role.iam_for_lambda_jester.arn}"
  handler       = "com.lapots.breed.jester.JesterNameGenerationHandler"
  runtime       = "java8"
}


resource "aws_api_gateway_rest_api" "jester_rest_api" {
  name = "JesterRestApi"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.jester_rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.jester_rest_api.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  authorization = "NONE"
  http_method   = "ANY"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  rest_api_id   = "${aws_api_gateway_rest_api.jester_rest_api.id}"
}

resource "aws_api_gateway_integration" "jester_lamda_function" {
  http_method = "${aws_api_gateway_method.proxy.http_method}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.jester_rest_api.id}"

  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.jester.invoke_arn}"
}

resource "aws_api_gateway_method" "jester_lambda_function_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.jester_rest_api.id}"
  resource_id   = "${aws_api_gateway_rest_api.jester_rest_api.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "jester_lambda_function_root" {
  rest_api_id = "${aws_api_gateway_rest_api.jester_rest_api.id}"
  resource_id = "${aws_api_gateway_method.jester_lambda_function_root.resource_id}"
  http_method = "${aws_api_gateway_method.jester_lambda_function_root.http_method}"

  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "${aws_lambda_function.jester.invoke_arn}"
}

resource "aws_api_gateway_deployment" "jester" {
  depends_on = [
    "aws_api_gateway_integration.jester_lamda_function",
    "aws_api_gateway_integration.jester_lambda_function_root"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.jester_rest_api.id}"
  stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.jester.arn}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_deployment.jester.execution_arn}/*/*"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.jester.invoke_url}"
}