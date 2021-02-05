output "vpc_id" {
  description = "The ID of the VPC"
  value = concat(aws_vpc.vpc.*.id, [""])[0]
}

output "vpc_name" {
  description = "The Name of the VPC"
  value = concat(aws_vpc.vpc.*.tags.Name, [""])[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of VPC"
  value = concat(aws_vpc.vpc.*.cidr_block, [""])[0]
}

output "public_route_tables" {
  description = "List of IDs of public route table"
  value = aws_route_table.public_route_table.*.id
}

output "private_route_tables" {
  description = "List of IDs of private route tables"
  value = aws_route_table.private_route_table.*.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value = aws_subnet.public_subnet.*.id
}

output "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks of public subnets"
  value = aws_subnet.public_subnet.*.cidr_block
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value = aws_subnet.private_subnet.*.id
}

output "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks of private subnets"
  value = aws_subnet.private_subnet.*.cidr_block
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = concat(aws_vpc.vpc.*.default_network_acl_id, [""])[0]
}

