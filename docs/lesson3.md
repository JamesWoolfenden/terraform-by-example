# Lesson 103 Templates

## Convert to using a template

Copy lesson 2 Terraform code, to lesson3 and delete *terraform.tfstate*.
Create a folder in lesson3 called template and add **hello.tmpl**:

```terraform
hello from ${ip} for ${user}
```

This is not much different than a jinja2 template, and achieves the same ends.

## Adding and using a Module

Add *module.ip.tf*

```terraform
module "ip" {
  source  = "JamesWoolfenden/ip/http"
  version = "0.2.8"
}
```

A module is a re-usable component of Terraform.
The source element "JamesWoolfenden/ip/http" is a reference to the Terraform Registry <https://registry.terraform.io/>
The details for a module can be seen there <https://registry.terraform.io/modules/JamesWoolfenden/ip/http/0.2.8>.
The version element allows us to fix the dependency.

The module requires the http provider, so that needs to added.

Add module reference *provider.http.tf*.

```terraform
provider "http" {
  version = "1.1"
}
```

Finally modify **null_resource.helloworld.tf**

```terraform
resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    # This is a comment
    command = "echo '${templatefile("${path.module}/template/hello.tmpl", { ip = module.ip.ip, user = var.user })}'"
  }
}
```

This now uses the *templatefile* function with supplied values for IP and user. Time to try it:

```bash
$ terraform apply
module.ip.data.http.ip: Refreshing state...

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
null_resource.hello_world (local-exec): Executing: ["cmd" "/C" "echo 'hello from 86.157.143.189 for guff'"]
null_resource.hello_world (local-exec): 'hello from 86.157.143.189 for guff'
null_resource.hello_world: Creation complete after 0s [id=3464807873684983853]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

hello_world = {
  "id" = "3464807873684983853"
}
```

So that's using modules, templates and Terraform functions. Major features but simple examples.

## terraform fmt

Terraform fmt rewrites "Terraform configuration files to a canonical format and style", that means no more arguments about spaces for layout. There is only the true path of fmt. Run it on your template.

```bash
$ terraform fmt
null_resource.helloworld.tf
```

Using the lessons from earlier refactor this chapter.

!!! note "Takeaways"
    - modules
    - templating
    - fmt
    - functions
    - registry
  
## Questions

## Documentation

<https://registry.terraform.io/modules/JamesWoolfenden/ip/http/0.2.8>
<https://www.terraform.io/docs/configuration/functions/templatefile.html>
<https://www.terraform.io/docs/configuration/modules.html>
