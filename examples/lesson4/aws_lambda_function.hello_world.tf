resource "aws_lambda_function" "hello_world" {
  filename         = "${path.module}/lambda.zip"
  function_name    = "hello-world"
  handler          = "lambda.lambda_handler"
  role             = data.aws_iam_role.basic.arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.hello-world.output_base64sha256
  tracing_config {
    mode = "PassThrough"
  }
}

