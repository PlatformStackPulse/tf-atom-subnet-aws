variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "vpc_id must not be empty."
  }
}

variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid CIDR notation."
  }
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  validation {
    condition     = length(var.availability_zone) > 0
    error_message = "availability_zone must not be empty."
  }
}

variable "map_public_ip_on_launch" {
  description = "Whether to auto-assign public IPs to instances"
  type        = bool
  default     = false
}
