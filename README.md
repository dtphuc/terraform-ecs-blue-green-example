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

1. This code will provision ECR repository as the beginning because the Infra and Application code are in same repo (for demo purpose).
Therefore, The Application cannot start because there is no image in ECR. But DO NOT WORRY. All you need is just deploy the service with CodePipeline. Then
the pipeline will build out ECR image and the application can pull image to start.
2. As I use GitHubv2 as Source within CodePipeline and establish connection via CodeStar. After you provision the resources, please follow the link
here (https://docs.aws.amazon.com/codepipeline/latest/userguide/update-github-action-connections.html) to link connection between Github and CodePipeline.
3. Remember to terminate the environment after using otherwise you will be cost.
