variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_account_name" {
  description = "Storage Account name (for private link)"
  type        = string
}

variable "storage_account_id" {
  description = "Storage Account ID (for private link)"
  type        = string
}

variable "api_management_hostname" {
  description = "API Management hostname"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

