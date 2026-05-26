output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "id" {
  description = "ID of the subnet"
  value       = try(aws_subnet.this[0].id, null)
}

output "arn" {
  description = "ARN of the subnet"
  value       = try(aws_subnet.this[0].arn, null)
}

output "cidr_block" {
  description = "CIDR block of the subnet"
  value       = try(aws_subnet.this[0].cidr_block, null)
}

output "availability_zone" {
  description = "AZ of the subnet"
  value       = try(aws_subnet.this[0].availability_zone, null)
}
