# Repos Patterns

How should my Infra code be structured?

In Git permissions, access, branching and PRS are done on a repo basis.
What can you reasonable manage as an owner/contributor should shape the structure.
What is a "manageable piece of infrastructure"?

## Landing Zone Pattern

When to use:

To set up an account for use by applications, control account.

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

Slow to apply, update, some account level infra is very slow to create, change or destroy.
Partial destroying of an account is risky.
Destroying whole environments at this level can often make little sense.
Harder for multiple people to work on at once
Not isolated.
Not simple in practice.
Ops like.
Controlling.
It's not really CI if you have a confirm an apply.
For many account level objects destroying them, makes sense only to the cultist (AD, IAM, AD, , Cloudtrail and other Security related resources)

Note
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

- Requires Invocation of multiple workspaces to make an environment
- Duplication of properties

Workspace Builds can be chained.

Note
Should never contain module code.

## Application Pattern

When to use:
For development teams to manage their own applications infrastructure, infrastructure code lives alongside application code. 
In DevOps, we empower development teams, so for dev teams to modify and manage.
I could be Terraform, Pulumi or SAM the strucuture should be something like:

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
- Isolated changes.
- Access control.

### Cons

- Duplication of properties across multi application

Note
Should never contain module code.

## Module Pattern

When to use:

Each in a separate repo always, for a manageable and reusable component.
Should always contain an example  implementation.

```
<code>
├──example\example
```

### Cons

- None

### Pros

- Simple
- Module has own life-cycle, versioning testing
- Re-use by design
