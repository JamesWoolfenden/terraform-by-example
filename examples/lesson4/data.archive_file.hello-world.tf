data "archive_file" "hello-world" {
  type        = "zip"
  source_file = "${path.module}/code/lambda.py"
  output_path = "${path.module}/lambda.zip"
}