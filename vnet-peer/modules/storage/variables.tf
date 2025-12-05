variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "private_endpoints_subnet_id" {
  description = "Subnet ID for private endpoints"
  type        = string
}

variable "private_dns_zone_storage_name" {
  description = "Private DNS Zone name for Storage"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

