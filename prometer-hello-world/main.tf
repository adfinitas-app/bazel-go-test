provider "aws" {
  version = "~> 2.0"
  region  = "eu-central-1"
}

resource "aws_iam_role" "lambda_role" {
  name = "prometer_hello_world_lambda_role"

  assume_role_policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole",
        Principal: {
          "Service": "lambda.amazonaws.com"
        },
        Effect: "Allow",
        Sid: ""
      }
    ]
  })
}

variable "artifact_path" {
  default = "../bazel-bin/prometer-hello-world/pkg.zip"
}

resource "aws_s3_bucket_object" "artifact" {
  bucket = "prometer-artifacts"
  key    = "hello-world.zip"
  source = var.artifact_path

  etag = filemd5(var.artifact_path)
}

resource "aws_lambda_function" "lambda" {
  function_name     = "prometer_hello_world_lambda"
  handler           = "main"
  role              = aws_iam_role.lambda_role.arn
  memory_size       = 128
  runtime           = "go1.x"
  timeout           = 15
  s3_bucket         = aws_s3_bucket_object.artifact.bucket
  s3_key            = aws_s3_bucket_object.artifact.key
  s3_object_version = aws_s3_bucket_object.artifact.version_id
  publish           = true
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "prometer_hello_world_dynamodb_policy"
  path        = "/"

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Action: [
          "dynamodb:*"
        ],
        Resource: "*",
        Effect: "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}