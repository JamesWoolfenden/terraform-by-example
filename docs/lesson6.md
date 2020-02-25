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

- Call Terraform on a given path. You may have to repeat yourself but it makes up for it in for clarity and portabliity.

### Files

Naming lowercase with _ separators.

Standard files
**variables.tf,outputs.tf, locals.tf**

I follow a 1 resource per file with files named after resources, although dumping in main.tf is common

- easier to navigate
- easier to compare
- easier to debug

### Testing

As alluded to there is no really satisfatory tool for unit

- Checkov.
- Terraform init, plan, fmt, validate.
- No great solution for unit testing
- Only test whats you can reasonably fix

Some use AWS-spec. I do not.

### Modules

I have a standard process for starting, building, documenting  and versioning modules.

- create build process for modules
- Follow TF module guidelines
- build for the Registry

- don't put all your modules in a monolith repo
- makes versioning hard
- private repos, are forgottenm not reused, never get seen or tested.

### Templates

Preference is for Clarity over to DRY

application vs infra

- reapplying tf and deploy time

demarcation between infra and code

expectation of responsibility

- at network level

IAM is problematic
explain
IAM test?
least privileges must be respected, i know its hard but....

providers/backend don't take vars
no vars in vars - see locals instead

whole env

handy data resource
passing vs data-source, don't import state

state and CM
show a change and state checking, deletion and recreate

## Refactor

Using the lessons from earlier refactor this chapter.

!!! note "Takeaways"
    - xxx

## Questions

## Documentation
