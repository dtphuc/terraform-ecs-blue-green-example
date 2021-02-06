# ECS Blue/Green Deployment with Terraform

## Terraform Project Layout

```sh
.
├── Dockerfile
├── Makefile
├── README.md
├── apps
│   └── index.html
├── buildspec.yaml
├── deployment
│   └── appspec_template.yaml
├── taskdef.json
├── terraform
│   ├── demo
│   │   ├── demo-service.tf
│   │   ├── ecs.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── roles.tf
│   │   └── vars.tf
│   ├── modules
│   │   ├── alb
│   │   ├── codebuild
│   │   ├── codedeploy
│   │   ├── codepipeline
│   │   ├── codepipeline-roles
│   │   ├── ecr
│   │   ├── ecs-cicd-pipeline
│   │   ├── ecs-cluster
│   │   ├── ecs-roles
│   │   ├── ecs-service
│   │   ├── ecs-with-bluegreen
│   │   ├── iam-roles
│   │   ├── security-groups
│   │   └── vpc
│   └── templates
│       ├── ecr_policy
│       ├── ecs_roles
│       └── ecs_task
├── terraform.tfstate
└── terraform.tfstate.backup

23 directories, 15 files
```

## Usage

* View a description of Makefile targets

```sh
$ make help
cleanup-state                  clean up the local state.
create-stacks                  Create stacks
destroy-stacks                 Destroy stacks
init-demo                      Init terraform
plan-destroy-stacks            Plan what to destroy
plan-stacks                    Plan what will create
```

* Create Stacks
```sh
$ AWS_PROFILE=demo make create-stacks
```

* Plan stacks

```sh
$ AWS_PROFILE=demo make plan-stacks 
```

* Delete Stacks

```sh
$ AWS_PROFILE=demo make destroy-stacks 
```

## Note

Remember to terminate the environment after using otherwise you will be cost.
