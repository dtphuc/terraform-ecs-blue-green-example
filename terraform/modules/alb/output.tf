output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_lb.this.*.dns_name, [""])[0]
}
output "load_balancer_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = concat(aws_lb.this.*.arn_suffix, [""])[0]
}

output "load_balancer_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = concat(aws_lb.this.*.id, [""])[0]
}

output "load_balancer_name" {
  description = "The Name of the load balancer we created."
  value       = concat(aws_lb.this.*.name, [""])[0]
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = concat(aws_lb.this.*.zone_id, [""])[0]
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = aws_lb_target_group.target_group.*.arn
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = aws_lb_listener.lb_http_listener.*.arn
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = aws_lb_listener.lb_http_listener.*.id
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = aws_lb_listener.lb_https_listener.*.arn
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = aws_lb_listener.lb_https_listener.*.id
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = aws_lb_target_group.target_group.*.name
}
