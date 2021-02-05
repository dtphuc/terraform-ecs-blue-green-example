resource "aws_ecr_repository" "this" {
  count                = var.create_ecr_repository ? length(var.repo_name) : 0
  name                 = var.repo_name[count.index]
  image_tag_mutability = var.image_tag_mutability
  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration == null ? [] : [var.encryption_configuration]
    content {
      encryption_type = encryption_configuration.value.encryption_type
      kms_key         = encryption_configuration.value.kms_key
    }
  }

  image_scanning_configuration {
    scan_on_push = var.scan_images_on_push
  }

  tags = merge(
    {
      Name      = var.repo_name[count.index]
      ManagedBy = "Terraform"
    },
    var.tags,
  )
}

data "template_file" "ecr_lifecycle_policy" {
  template = file("${path.module}/../../templates/ecr_policy/lifecycle_policy.json")
}

resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.enable_lifecycle_policy ? 1 : 0
  repository = element(concat(aws_ecr_repository.this.*.name, list("")), 0)
  policy     = data.template_file.ecr_lifecycle_policy.rendered
}

data "template_file" "ecr_full_access" {
  template = file("${path.module}/../../templates/ecr_policy/ecr_full_access.json")
  vars = {
    principals_full_access = var.principals_full_access
  }
}

data "template_file" "ecr_read_only" {
  template = file("${path.module}/../../templates/ecr_policy/ecr_read_only.json")
  vars = {
    principals_read_only = var.principals_read_only
  }
}

resource "aws_ecr_repository_policy" "fullaccess" {
  count      = var.enable_ecr_policy ? var.enable_full_access : 0
  repository = element(concat(aws_ecr_repository.this.*.name, list("")), 0)
  policy     = data.template_file.ecr_full_access.rendered
}

resource "aws_ecr_repository_policy" "readonly" {
  count      = var.enable_ecr_policy ? var.enable_readonly_access : 0
  repository = element(concat(aws_ecr_repository.this.*.name, list("")), 0)
  policy     = data.template_file.ecr_read_only.rendered
}