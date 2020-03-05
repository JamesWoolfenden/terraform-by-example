# Lesson 8 Repository Patterns

## How should my Infra code be structured

In Git permissions, access, branching and PRS are set-up on a repository basis.
What can you reasonable manage as an owner/contributor should shape the structure.
What is a "manageable piece of infrastructure"?
There is no one answer, it depends on the project aims and the situation you start in. Your IAC will use a combination of these approaches.ld
Each folder shou be directly run-able by Terraform:

```cli
environment\eu-west-1\test$ terraform apply
...
```

### Branching

Code submitted to master via PRS on very short lived feature branches, or trunk based development. Don't branch by environment. Branching with state references is difficult/hazardous.

## Landing Zone Pattern

When to use:

To set up an account for use by applications, to control account level resources e.g. VPC, security.

```
├──environments
      ├──region
	      ├──dev
	      ├──test
          
```

### Pros

- One project to rule them all.
- Simple in design.

### Cons

- Slow to apply, update, some account level infra is very slow to create, change or destroy.
- Partial destroying of an account is risky.
- Whole account apply is risky, unless you plan first.
- Destroying whole environments at this level can often make little sense.
- Harder for multiple people to work on at once
- Lack of isolation, 2 or more developers working on same environment.
- Not simple in practice.
- Ops like.
- Very Controlling.
- It's not really CI if you have a confirm an apply.
- For many account level objects destroying them, rarely practical makes sense  (AD, IAM, AD, Cloudtrail and other Security related resources)
- Nuclear level blast radius.
  
!!! note
    Should never contain module code.

## Separation Pattern

When to use:
Some objects are neither the landing Zone nor a single services application code.
Each environment/workspace <name> has a build process and life-cycle.

```
├──eks
   ├──region
      ├──dev <eks-region-dev>
      ├──test <eks-region-test>
├──elasticsearch
   ├──region
	  ├──dev <elasticsearch-region-dev>
      ├──test <elasticsearch-region-test>
      ├──other
```

### Pros

- Change is isolated
- Blast radius limited

### Cons

- Requires Invocation of multiple workspaces to make an environment.
- Duplication of properties.

!!! note
    Should never contain module code.
    Workspace Builds can be chained.

## Application Pattern

When to use:
For development teams to manage their own applications infrastructure, infrastructure code lives alongside application code.
In DevOps, we empower development teams, so for dev teams to modify and manage.
It could be Terraform, Pulumi <https://www.pulumi.com/>, Serverless <https://serverless.com/https://serverless.com/> or SAM <https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html> the structure should still be something like:

```
├──src
├──iac
    ├──lambda
         ├──dev
	     ├──test
    ├──service
	     ├──dev
         ├──test
         ├──other
```

### Pros

- Run infra provisioning as part of your deployment process.
- Isolated changes.n
- Access control.

### Cons

- Duplication of properties across multi application

!!! note
    Should never contain module code.

## Module Pattern

When to use:

Once you've created a reusable module, it should reside in a separate repository, so that it is a manageable and reusable component with ots own life-cycle.
A module should always contain an example implementation and documentation.

```
<code>
├──example
         ├──examplea
         ├──exampleb

```

### Cons

- None

### Pros

- Simple.
- Module has own life-cycle, versioning and testing process.
- Re-use by design.
- allows you to fix module versions across environments and promote a module through an applications stages.

## Refactor

!!! note "Takeaways"
    take this  

## Exercises

## Questions

## Documentation
