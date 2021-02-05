# Create IAM Managed Policy 
resource "aws_iam_policy" "iam_policy" {
  count  = var.create_policy ? 1 : 0
  name   = var.iam_policy_name
  path   = var.iam_policy_path
  policy = var.iam_policy_document
}

# Create IAM Roles
resource "aws_iam_role" "iam_role" {
  count                 = var.create_role ? 1 : 0
  name                  = var.aws_role_name
  assume_role_policy    = var.assume_role_policy
  path                  = var.aws_role_path
  max_session_duration  = var.max_session_duration
  description           = var.role_description
  permissions_boundary  = var.permissions_boundary_arn
  force_detach_policies = var.force_detach_policies
  tags = merge(
    {
      Name      = var.aws_role_name
      ManagedBy = "Terraform"
    },
    var.tags,
  )
}

# Attach Policy to Roles
resource "aws_iam_role_policy_attachment" "iam_policy_attachment" {
  count      = var.create_role ? length(var.role_policy_arns) : 0
  role       = aws_iam_role.iam_role[0].id
  policy_arn = element(var.role_policy_arns, count.index)
}

resource "aws_iam_role_policy" "customPolicy" {
  count  = var.create_policy ? 1 : 0
  name   = var.iam_policy_name
  policy = aws_iam_policy.iam_policy[0].policy
  role   = aws_iam_role.iam_role[0].id
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "iam_profile" {
  count = var.create_instance_profile ? 1 : 0
  name = var.aws_instance_profile_name
  role = aws_iam_role.iam_role[0].name
}
