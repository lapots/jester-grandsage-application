terraform {
  backend "s3" {
    bucket = "s3-terraform-state-backend"
    region = "eu-central-1"
    key = "jester-lambda-function/terraform.tfstate"
  }
}

variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}

provider "aws" {
  region = "eu-central-1"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = <<EOF
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

# investigate need
#resource "aws_lambda_permission" "allow_bucket" {
  #statement_id = "AllowExecutionFromS3Bucket"
  #action = "lambda:InvokeFunction"
  #function_name = "${aws_lambda_function.jester.arn}"
  #principal = "s3.amazonaws.com"
  #source_arn = "${aws_s3_bucket.game_rules.arn}"
#}

resource "aws_lambda_function" "jester" {
  filename = "build/libs/jester-lambda-function-1.0.jar"
  function_name = "jester_lambda_function"
  role = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "com.lapots.breed.jester.XXXX"
  runtime = "java8"
}
