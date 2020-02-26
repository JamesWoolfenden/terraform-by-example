# Lesson 7

After starting a project getting Access to a Cloud account/project, creating a state bucket is step 2.

This is usually an S3 bucket, Cloud storage, Blob Storage or Terraform Cloud Workspace.

Having a remotely managed state file allows you to cooperate on using and creating infrastructure code.

A statefiles' location is determined when you invoke Terraform init.

--

## Local State

When you first start and apply your template, a state file is left behind.

```json
{
  "version": 4,
  "terraform_version": "0.12.20",
  "serial": 9,
  "lineage": "c430de7f-a3f5-e2d1-f912-0beb92340157",
  "outputs": {},
  "resources": [
    {
      "mode": "data",
      "type": "archive_file",
      "name": "hello-world",
      "provider": "provider.archive",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "excludes": null,
            "id": "57f31171437c7fb9dde5382167d421d966eb0707",
            "output_base64sha256": "rna/NuWSsy6/EZaDG7bGpz1rfX1bawF3OAKjyjBc/i8=",
            "output_md5": "5ddf9823dd4e8dbf3c0d8c2e642a2a05",
            "output_path": "./lambda.zip",
            "output_sha": "57f31171437c7fb9dde5382167d421d966eb0707",
            "output_size": 262,
            "source": [],
            "source_content": null,
            "source_content_filename": null,
            "source_dir": null,
            "source_file": "./code/lambda.py",
            "type": "zip"
          }
        }
      ]
    },
    {
      "mode": "data",
      "type": "aws_iam_role",
      "name": "basic",
      "provider": "provider.aws",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "arn": "arn:aws:iam::680235478471:role/lambda_basic_execution",
            "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}",
            "assume_role_policy_document": null,
            "create_date": "2016-10-04T13:19:01Z",
            "description": "",
            "id": "lambda_basic_execution",
            "max_session_duration": 3600,
            "name": "lambda_basic_execution",
            "path": "/",
            "permissions_boundary": "",
            "role_id": null,
            "role_name": null,
            "unique_id": "AROAJLLUCPL4OFV5WAGMM"
          }
        }
      ]
    },
    {
      "mode": "managed",
      "type": "aws_lambda_function",
      "name": "hello_world",
      "provider": "provider.aws",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "arn": "arn:aws:lambda:us-west-2:680235478471:function:hello-world",
            "dead_letter_config": [],
            "description": "",
            "environment": [],
            "filename": "./lambda.zip",
            "function_name": "hello-world",
            "handler": "lambda.lambda_handler",
            "id": "hello-world",
            "invoke_arn": "arn:aws:apigateway:us-west-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-west-2:680235478471:function:hello-world/invocations",
            "kms_key_arn": "",
            "last_modified": "2020-02-22T18:15:37.396+0000",
            "layers": null,
            "memory_size": 128,
            "publish": false,
            "qualified_arn": "arn:aws:lambda:us-west-2:680235478471:function:hello-world:$LATEST",
            "reserved_concurrent_executions": -1,
            "role": "arn:aws:iam::680235478471:role/lambda_basic_execution",
            "runtime": "python3.7",
            "s3_bucket": null,
            "s3_key": null,
            "s3_object_version": null,
            "source_code_hash": "rna/NuWSsy6/EZaDG7bGpz1rfX1bawF3OAKjyjBc/i8=",
            "source_code_size": 262,
            "tags": null,
            "timeout": 3,
            "timeouts": null,
            "tracing_config": [
              {
                "mode": "PassThrough"
              }
            ],
            "version": "$LATEST",
            "vpc_config": []
          },
          "private": "eyJlMmJmYjczMC1lY2FhLTExZTYtOGY4OC0zNDM2M2JjN2M0YzAiOnsiY3JlYXRlIjo2MDAwMDAwMDAwMDB9fQ=="
        }
      ]
    }
  ]
}
```

It holds a record of what happened.
If you plan to persist what you make, or have more than 1 user, remote state is a must.

Do not check in **Terraform.tfstate**, EVER, as it can contain secrets.

## Remote state

So just about every project should use remote state to secure it's work.
Ti use remote state, a remote state bucket reference is required, in S3, you have a similar section in your **terraform.tf**:

```HCL
terraform {
  backend "s3" {
    bucket = "allthestates"
    key    = "phrasing/terraform.tfstate"
    region = "eu-west-1"
  }
}
```

For state buckets the following are critically important:

- Locking.
  Considering a locking DynamocDB table early.
- It's a private bucket.
- Encryption. It can contain secrets
- Do not edit manually.
- Plan to run your Terraform regularly as part of a configuration management process.
- A State Bucket per AWS account/GCP project/Azure Subscription.
- S3 versioning.
- A Statefile per template.

And make sure you have unique statefiles. If you use the same statefile in 2 templates what will happen? Try 2 different statefiles from the same template.

## Reading remote state

A one point there was pretty much only one way of finding out what happened in  another template, the remote state datasource in Terraform:

```HCL
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "allthestates"
    key    = "phrasing/terraform.tfstate"
    region = "eu-west-1"
  }
}
```

This allows you to read the output, if any, of the state file of another template, if permitted.

That Datasource used to be the only way of the finding out results of other runs.

There are now almost as many datasource objects as resources, so you  don't have to know it's location, which makes for looser coupling.

This also allows you to conditionally create or read objects in Terraform.
You might still need this, but it's probably a code smell.

### Importing

Most resources support **Terraform import** statement this allows you to import existing resource into Terraform as if you'd created them.

## Refactor

Using the lessons from earlier refactor this chapter.

!!! note "Takeaways"
    - Always use remote state
    - Locking
    - never checkin, update your, *.gitignore* with an exclusion.

## Exercises

1. Create a statebucket with Terraform.

2. Migrate to remote state for the lambda template with created in step 4.

3. Create an example to use conditional creation of resources. What could go wrong?

4. How do you manage locking on an S3 bucket?

5. A colleague created S3 bucket via the console, but it should have been done via Terraform, it can't be deleted, how do I turn this into a managed resource?

## Questions

Why might using conditional creation using datasources be a bad idea?

What will happen if you share statefiles across templates?

What is drift?

## Documentation

<https://www.terraform.io/docs/backends/types/index.html>
<https://registry.terraform.io/search?q=state>