# Lesson 4

## AWS Auth

Test you have AWS authentication with:

```cli
aws s3 ls
```

## Add Python code

Make a folder called code

Add **lambda.py**

```python
import json

def lambda_handler(event, context):
    
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
```

## Terraform Archive

Create a zip of the Python code with **data.archive_file.helloworld.tf**

```HCL
data "archive_file" "hello-world" {
  type        = "zip"
  source_file = "${path.module}/code/lambda.py"
  output_path = "${path.module}/lambda.zip"
}
```

## Add Providers

Supply the Auth and the Providers needed for

- zip
- aws

Add **providers.tf**

```cli
provider "aws" {
    version="~>2.50"
    region="us-west-2"
}

provider "archive" {
    version="1.3"
}
```

## Add the Lambda resource

Create **aws_lambda_function.hello_world.tf**

```cli
resource "aws_lambda_function" "hello_world" {
 filename     = "${path.module}/lambda.zip"
 function_name= "hello-world"  
 handler      = "lambda.lambda_handler"
 role         = data.aws_iam_role.basic.arn
 runtime      = "python3.7"
 source_code_hash=data.archive_file.hello-world.output_base64sha256
}
```

This brings the whole template together, most of this is pretty obvious,
*source_code_hash* serves two purposes, the hash will change if the zipped python changes, and it creates a link between the archive and the lambda resources to ensure that the zip happens first.

## Role

Finally the Lambda needs a role for authentication, there is a pre-existing basic role for executing lambda "lambda_basic_execution".
Create data **aws_iam_role.basic.tf** with:

```hcl
data "aws_iam_role" "basic" {
    name="lambda_basic_execution"
}
```

Time to build and apply the Lambda.

```CLI
$ terraform apply
data.archive_file.hello-world: Refreshing state...
data.aws_iam_role.basic: Refreshing state...

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_lambda_function.hello_world will be created
  + resource "aws_lambda_function" "hello_world" {
      + arn                            = (known after apply)
      + filename                       = "./lambda.zip"
      + function_name                  = "hello-world"
      + handler                        = "lambda.lambda_handler"
      + id                             = (known after apply)
      + invoke_arn                     = (known after apply)
      + last_modified                  = (known after apply)
      + memory_size                    = 128
      + publish                        = false
      + qualified_arn                  = (known after apply)
      + reserved_concurrent_executions = -1
      + role                           = "arn:aws:iam::680235478471:role/lambda_basic_execution"
      + runtime                        = "python3.7"
      + source_code_hash               = "rna/NuWSsy6/EZaDG7bGpz1rfX1bawF3OAKjyjBc/i8="
      + source_code_size               = (known after apply)
      + timeout                        = 3
      + version                        = (known after apply)

      + tracing_config {
          + mode = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_lambda_function.hello_world: Creating...
aws_lambda_function.hello_world: Creation complete after 9s [id=hello-world]
```

## Testing

You can verify that the Lambda works by invoking it at the command line.

```cli
$ aws lambda invoke --function-name hello-world hello.json
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

## Refactor

Using the lessons from earlier refactor this chapter.

!!! note "Takeaways"
    - Auth
    - Archive
    - Lambda
    - Data resource
    - Cli

## Questions

## Documentation
