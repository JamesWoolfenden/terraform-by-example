# Lesson 2

## Variables

We are going to modify the lesson 1 code to use a variable.

```terraform
resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    # This is a comment
    command = "echo 'hello world from ${var.user}'"
  }
}
```

You don't need to run Terraform init as there's been no change to providers or modules, so it's straight to using apply.

```bash
$terraform apply

Error: Reference to undeclared input variable

  on null_resource.helloworld.tf line 4, in resource "null_resource" "hello_world":
   4:     command = "echo 'hello world from ${var.user}'"

An input variable with the name "user" has not been declared. This
variable can be declared with a variable "user" {} block.
```

That didn't work.
You need to declare the variable **user**, you could just add the block below to any Terraform file, but the correct way is to add a file called **variables.tf** and use that. This is a convention.

```terraform
variable "user" {
  type=string
}
```

And apply.

```bash
$ terraform apply
var.user
  Enter a value:
```

You could work with Terraform like this, and type in the values each time it runs. Thankfully, there are other options.

## Defaults

Modify your variable declaration to have a default value.

```terraform
variable "user" {
  type=string
  default="DEFAULT"
}
```

## Overrides

```bash
terraform apply -var "user=SHELL"
```

What happened?

```bash
terraform apply -var 'user=SHELL'
null_resource.hello_world: Refreshing state... [id=5019739039794330655]

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

What should have happened?
Hopefully a different output showing the new value, so why didn't it?
This is because you're using a shell command in a null resource there is no state record.
Check your state file **terraform.tfstate**

```json
{
  "version": 4,
  "terraform_version": "0.12.20",
  "serial": 10,
  "lineage": "10c120f2-386d-3c02-5395-9b2b9e26c5ec",
  "outputs": {},
  "resources": [
    {
      "mode": "managed",
      "type": "null_resource",
      "name": "hello_world",
      "provider": "provider.null",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "1300466885639272531",
            "triggers": null
          },
          "private": "bnVsbA=="
        }
      ]
    }
  ]
}
```

Destroy your template:

```bash
$terraform destroy
null_resource.hello_world: Refreshing state... [id=7244294109451146186]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # null_resource.hello_world will be destroyed
  - resource "null_resource" "hello_world" {
      - id = "7244294109451146186" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

null_resource.hello_world: Destroying... [id=7244294109451146186]
null_resource.hello_world: Destruction complete after 0s```
```

Now try supplying value again and it will work:

```bash
$ terraform apply -var 'user=SHELL'

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.hello_world will be created
  + resource "null_resource" "hello_world" {
      + id = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

null_resource.hello_world: Creating...
null_resource.hello_world: Provisioning with 'local-exec'...
null_resource.hello_world (local-exec): Executing: ["cmd" "/C" "echo 'hello world from SHELL'"]
null_resource.hello_world (local-exec): 'hello world from SHELL'
null_resource.hello_world: Creation complete after 0s [id=4486592786807831720]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

## environmental variables

Add an environmental variable to your shell call *TF_VAR_user* to your shell.

export TF_VAR_user="environment"
or
$env:TF_VAR_user="environment"

And apply.

```bash
$ export TF_VAR_user="environment"
✔ /mnt/c/code/mkdocs/terraform-by-example/examples/lesson2 [master L|…9]
09:29 $ terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # null_resource.hello_world will be created
  + resource "null_resource" "hello_world" {
      + id = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

So Terraform looks for the values of your variables as long as they have the prefix **TF_VAR_** but there are exceptions.

## tfvars

Terraform can also take the values of variables from a tfvars file. Make sure to erase your environmental variables from the previous section.
Add a file called **guff.tfvars**

```terraform
user="guff"
```

And apply.

```bash
$ terraform apply
var.user
  Enter a value:
```

So that didn't work. There's a convention, the old convention is to use a file called **terraform.tfvars** but you can now use multiple *tfvar* files as long as they have *auto* in their name. Rename **guff.tfvars** **guff.auto.tfvars** and re-apply.

## Outputs

It's also good practice to include your outputs. This helps with debugging and making your template or module extendible.
By convention it's called  **Outputs.tf**

```terraform
output "hello_world" {
  description = "The Output of the Null resource"
  value       = null_resource.hello_world
}
```

Now when you apply you should see something like this at the end of your output;

```bash
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

hello_world = {
  "id" = "562214568453658147"
}
```

!!! note "Takeaways"
    - variables
    - overrides
    - syntax checking
    - outputs
    - defaults
    - cli usage
    - environmental variables
    - tfvars
    - state with null resource
      local execs are contents not infrastructure so there's no record in state

## Exercises

1. What other data types can a variable be? Modify the example to user a list.

## Questions

## Documentation

For more on variables see the Hashicorp docs:
<https://www.terraform.io/docs/configuration/variables.html>