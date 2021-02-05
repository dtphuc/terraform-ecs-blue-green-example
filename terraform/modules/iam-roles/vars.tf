variable "create_role" {
  description = "Whether to create an IAM role or not"
}
variable "create_policy" {
  description = "Whether to create an IAM policy or not"
}
variable "create_instance_profile" {
  description = "Whether to create an Instance Profile or not"
}
variable "aws_role_name" {
  description = "The name of the role"
}

variable "aws_role_path" {
  description = "The path to the role"
  default     = "/"
}
variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that you want to set for the specified role"
  default     = 43200
}
variable "role_description" {
  description = "The description of the IAM Role"
}
variable "permissions_boundary_arn" {
  description = "The ARN of the policy that is used to set the permission boundary"
}
variable "iam_policy_name" {
  description = "The name of the iam policy"
}
variable "iam_policy_path" {
  description = "The path of the iam policy"
}
variable "iam_policy_document" {
  description = "The policy document. This is a JSON formatted string"
}
variable "aws_instance_profile_name" {
  description = "The profile's name "
}
variable "force_detach_policies" {
  description = "Specifies to force detaching any policies the role has before destroying it."
}

variable "role_policy_arns" {
  description = "List of policy ARNs to use for admin role"
  type        = list(string)
}

variable "assume_role_policy" {
  description = "Assume Role Policy"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}