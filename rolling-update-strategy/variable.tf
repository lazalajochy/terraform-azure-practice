variable "revision_suffix" {
  description = "Suffix of the current active Container App revision (optional, for canary/blue-green deployments)"
  type        = string
  default     = ""
}
