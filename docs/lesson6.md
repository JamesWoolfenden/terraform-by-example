# Lesson 6

## Structure

In the last Chapter we covered tools, this chapter focussed on structure.

Terraform is a declarative data driven language.

- As a rule design for replication and clarity and not for logic constructs.
- Design for a lower cognitive load.

### How should I layout Terraform project

When I first started writing Terraform I wrote a lot of wrapper scripts now I aim to write none.

- no wrapper scripts
Exception- Well I sometime create a makefile or equivalent.

- Call Terraform on a given path. You may have to repeat yourself but it makes up for it in for clarity and portability.

- For application related infrastructure, keep the tf with the code it relates to.

- Account level/environments code is best kept separate, this would be VPC, routing, security. With Cloud native services, The separation between Infrastructure from application is getting less defined.

- Preference is for Clarity, repeat for clarity.

### Files

Naming lowercase with _ separators.

Standard files
**variables.tf,outputs.tf, locals.tf**

I follow a 1 resource per file with files named after resources, although dumping in main.tf is common

- easier to navigate
- easier to compare
- easier to debug

### Testing

As alluded previously to, I have yet to fins a satisfactory tool/solution for unit testing

- Checkov.
- Terraform init, plan, fmt, validate.
- Only test whats you can reasonably be expected to fix.

Some use AWS-spec. I do not.

### Modules

I have a standard process and skeleton for starting, building, documenting  and versioning modules.

This is the MVP of module creation:

Make a copy of the Lambda code from lesson 4.

Create a folder called example, and move the provider to it.
Then add **module.lambda.tf**

```HCL
module "lambda" {
    source="../"
}
```

in **aws_lambda_function.hello_world.tf**

```HCL
resource "aws_lambda_function" "hello_world" {
  filename         = "${path.module}/lambda.zip"
  function_name    = var.name
  handler          = "lambda.lambda_handler"
  role             = data.aws_iam_role.basic.arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.hello-world.output_base64sha256
}
```

And add **variables.tf**

```HCL
variable "name" {
  description="The name of the lambda"
  type=string
}
```

Your module now requires the value for *var.name*, add that to your module reference in example, put your own value for the name:

```HCL
module "lambda" {
    source= "../"
    name  = "James made me do it"
}
```

Open the example folder in your console, and Terraform init and apply.

That's the basics.

- Create build process for modules.
- Build to TF module guidelines.
- Build for the Registry.
- Don't put all your modules in a monolith repo, amongst other things this makes versioning hard.
- private repos, are forgotten not reused, never get seen or tested.

## Refactor

Using the lessons from earlier refactor this chapter.

## Exercises

1. Add a reference to a version of a module.

!!! note "Takeaways"
    - modules are like micro-services, keep them separate.

## Questions

## Documentation

<https://www.terraform.io/docs/modules/index.html>
