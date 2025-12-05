variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for API Management"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID for DNS linking"
  type        = string
}

variable "container_app_url" {
  description = "Container App URL (internal)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

