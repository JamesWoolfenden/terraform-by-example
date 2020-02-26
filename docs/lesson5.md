# Lesson 5

## Preferred Tools and set-up

The difference between a success and failure can be down to the tooling.
These options are proven.

### VCS

The preference is always to use SAS VCS rather than on premise or self hosted solutions, as this gives you the best access to integrating with other tools.

- **Github**.
  Has better integration with Terraform, the Registry and Cloud, and other CI tools and the public clouds.

- **Gitlab**.
  Does more than just look after your code.

### CI/CD

Having versioned modules is essential, Infra code should be treated exactly as application code.

- **Github Actions**
  This provides basic functionality for builds without having to leave the platform. I use this for all new module pipelines. Free.
  
  The example below checks and validates and module and then versions it.

```yaml
---
name: Verify and Bump
on:
  push:
    branches:
      - master
jobs:
  examples:
    name: "Terraform (examples)"
    runs-on: ubuntu-latest
    steps:
      - name: "Checkout"
        uses: actions/checkout@master
      - name: "Terraform Init"
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.20
          tf_actions_subcommand: "init"
          tf_actions_working_dir: "example/examplea"
      - name: "Terraform Validate"
        uses: hashicorp/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.20
          tf_actions_subcommand: "validate"
          tf_actions_working_dir: "example/examplea"

  build:
    name: versioning
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Bump version and push tag
        uses: anothrNick/github-tag-action@master
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          DEFAULT_BUMP: patch
          WITH_V: "true"
    needs: examples

```

- **Terraform Cloud**
  Terraform Enterprise now with a free tier, a good base if all your builds are only infrastructure.

- **CircleCI**
  The stand out best current option for CI. Given a choice, this is it.
  Below, is a basic node CI process. Name it 

```yaml
version: 2.1

orbs:
  aws-cli: circleci/aws-cli@0.1.13

jobs:
  build:
    working_directory: ~/build
    docker:
      - image: circleci/node
    steps:
      - checkout
      - restore_cache:
          key: dependency-cache-{{ checksum "package.json" }}
      - run:
          name: install-npm
          command: npm install
      - run:
          name: pack
          command: npm pack
      - run:
          name: copy
          command: |
            mkdir ~/output/
            cp *.tgz ~/output/
      - save_cache:
          key: dependency-cache-{{ checksum "package.json" }}
          paths:
            - ./node_modules
      - store_artifacts:
          path: ~/output
  deploy:
    working_directory: ~/build
    docker:
      - image: circleci/node
    steps:
      - checkout
      - aws-cli/install
      - aws-cli/configure
      - run:
          name: Deploy
          command: npm run deploy

workflows:
  version: 2
  build-and-deploy:
    jobs:
      - build
      - deploy:
          requires:
            - build
          filters:
            branches:
              only: master
          context: AWS

```

- **Travis**.
  The old best SAS option and still good enough. Used for all old module pipelines. Free for Public repos.
  The example below also does a basic tests set-up and versioning for a given module.

```YAML
---
# yamllint disable rule:line-length
dist: trusty
sudo: required
services:
  - docker
branches:
  only:
    - master
env:
  - VERSION="0.1.$TRAVIS_BUILD_NUMBER"
addons:
  apt:
    packages:
      - git
      - curl

before_script:
  - export TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
  - curl --silent --output terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  - unzip terraform.zip ; rm -f terraform.zip; chmod +x terraform
  - mkdir -p ${HOME}/bin ; export PATH=${PATH}:${HOME}/bin; mv terraform ${HOME}/bin/
  - terraform -v

script:
  - terraform init -get-plugins -backend=false -input=false
  - terraform init -get -backend=false -input=false
  - terraform fmt
  - bash validate.sh

after_success:
  - git config --global user.email "builds@travis-ci.com"
  - git config --global user.name "Travis CI"
  - export GIT_TAG=$VERSION
  - git tag $GIT_TAG -a -m "Generated tag from TravisCI build $VERSION"
  - git push --quiet https://$TAGAUTH@github.com/jameswoolfenden/terraform-aws-snstoslack $GIT_TAG > /dev/null 2>&1
```

- **TeamCity**.
  If you're not using a SAS product this is best option.
  <https://github.com/JamesWoolfenden/terraform-aws-teamcity>

I'm sure there are other good SAS CI tools available e.g. Codefresh, I could easily do a list of tools to avoid.

## IDE

I haven't used anything except VSCode for sometime.

- **VSCode**
  - Extension <https://marketplace.visualstudio.com/items?itemName=mauve.terraform>
- **Atom**.
  I used to use this.
- **Intellij**
  Also supports an HCL plugin.

## Terraform Tools

I'm always on the lookout for new and improved tools, so surprisingly this a short list, but these ones have proven to be essential.

- **Terraformer** <https://github.com/GoogleCloudPlatform/terraformer>.
  This reverse engineers infrastructure into Terraform, supports just about anything.

- **Checkov** <https://checkov.io>.
  The stand-out best analysis tool for Terraform. Tests against the CIS Standards.

- **The Pre-commit framework** <https://pre-commit.com/>.
  Manages your code, does many useful things like not letting add secrets to your code.
  My current set up for pre-commit is supplied **.pre-commit-config.yaml** this is suitable for Terraform only repositories.

```yaml
---
# yamllint disable rule:line-length
default_language_version:
  python: python3
repos:
  - repo: git://github.com/pre-commit/pre-commit-hooks
    rev: v2.5.0
    hooks:
      - id: check-json
      - id: check-merge-conflict
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: pretty-format-json
        args:
          - --autofix
      - id: detect-aws-credentials
      - id: detect-private-key
  - repo: git://github.com/Lucas-C/pre-commit-hooks
    rev: v1.1.7
    hooks:
      - id: forbid-tabs
        exclude_types: [python, javascript, dtd, markdown, makefile, xml]
        exclude: binary|\.bin$
  - repo: git://github.com/jameswoolfenden/pre-commit-shell
    rev: 0.0.2
    hooks:
      - id: shell-lint
  - repo: git://github.com/igorshubovych/markdownlint-cli
    rev: v0.22.0
    hooks:
      - id: markdownlint
  - repo: git://github.com/adrienverge/yamllint
    rev: v1.20.0
    hooks:
      - id: yamllint
        name: yamllint
        description: This hook runs yamllint.
        entry: yamllint
        language: python
        types: [file, yaml]
  - repo: git://github.com/jameswoolfenden/pre-commit
    rev: 0.1.17
    hooks:
      - id: terraform-fmt
      - id: checkov-scan
        language_version: python3.7
      - id: tf2docs
        language_version: python3.7

```

### Testing

You may notice the lack of unit testing tooling, this is not an omission.

### Exercises

1. Create an Account on Terraform cloud - <https://app.terraform.io>

2. Look at the published modules modules on the Registry <https://registry.terraform.io>

!!! note "Takeaways"
    - tools
    - no unit practical unit testing

## Questions

1. Why are the options for unit testing, what's wrong?

## Documentation

There is publicly maintained list of Terraform tools
<https://github.com/shuaibiyy/awesome-terraform>