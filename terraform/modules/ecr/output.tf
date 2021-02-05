output "registry_id" {
  value = element(concat(aws_ecr_repository.this.*.registry_id, list("")), 0)
}
output "repository_url" {
  value = element(concat(aws_ecr_repository.this.*.repository_url, list("")), 0)
}
output "ecr_name" {
  value = element(concat(aws_ecr_repository.this.*.name, list("")), 0)
}
output "ecr_arn" {
  value = element(concat(aws_ecr_repository.this.*.arn, list("")), 0)
}


