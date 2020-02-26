# Lesson 7

After getting Access to an a Cloud account/project, creating a state bucket is step 2.

This is usually an S3 bucket, Cloud storage, Blob Storage or Terraform Cloud Workspace.

A statefiles location is determined when you invoke Terraform init.

--

## State

If you plan do keep what you make, or have more than 1 user, remote state is a must.
Do not check in **Terraform.tfstate**, EVER, it can contain secrets.

For state buckets the flowing are critically important:

- Locking
- Encryption
- Versioning
- Do not edit manually

And make sure you have unique statefiles.

## Remote state

The state bucket reference, for S3 ensure you have a similar section in your **terraform.tf**:

```HCL
terraform {
  backend "s3" {
    bucket = "allthestates"
    key    = "phrasing/terraform.tfstate"
    region = "eu-west-1"
  }
}
```

- Plan to run your Terraform regularly as part of a configuration management process.

- A State Bucket per AWS account/GCP project/Azure Subscription.

- A Statefile per template.

## Reading remote state

A one point there was pretty much only one datasource in Terraform:

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

This allows you to read the output, if any, of the state file, if permitted.

That Datasource was the only way of the finding out results of other runs.

There are now almost as many datasource objects as resources, so you  don't have to know it's location, which makes for looser coupling.
It also allows you to conditionally create or read objects in Terraform.
You might still need this, but it's probably a code smell.

## Refactor

Using the lessons from earlier refactor this chapter.

!!! note "Takeaways"
    - xxx

## Exercises

1. Create a statebucket with Terraform.

2. Migrate to remote state for the lambda template with created in step 4.

3. Create an example to use conditional creation of resources.

4. How to manage locking on an S3 bucket.

5. A colleague created S3 bucket via the console but it should have been done via Terraform, it can't be deleted, how do i turn this into a managed resource?

## Questions

Why might using conditional creation using datasources be a bad idea?

What will happen if you share statefiles across templates?

What is drift?

## Documentation

<https://www.terraform.io/docs/backends/types/index.html>
