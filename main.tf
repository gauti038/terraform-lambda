data "archive_file" "gautam_microservice" {
  type = "zip"

  source_dir  = "${path.module}/microservice"
  output_path = "${path.module}/microservice.zip"
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "gautam-lambda"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "microservice" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "microservice.zip"
  source = data.archive_file.gautam_microservice.output_path

  etag = filemd5(data.archive_file.gautam_microservice.output_path)
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_lambda_function" "getAPI" {
  function_name = "getAPI"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.microservice.key

  runtime = "nodejs12.x"
  handler = "main.getAPI"

  source_code_hash = data.archive_file.gautam_microservice.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "getAPI" {
  name              = "/aws/lambda/${aws_lambda_function.getAPI.function_name}"
  retention_in_days = var.logs_retention_in_days
}

resource "aws_lambda_function" "postAPI" {
  function_name = "postAPI"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.microservice.key

  runtime = "nodejs12.x"
  handler = "main.postAPI"

  source_code_hash = data.archive_file.gautam_microservice.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "postAPI" {
  name              = "/aws/lambda/${aws_lambda_function.postAPI.function_name}"
  retention_in_days = var.logs_retention_in_days
}


