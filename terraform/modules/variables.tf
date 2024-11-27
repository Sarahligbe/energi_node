variable "name" {
  description = "Base name for the IAM resources."
  type        = string
}

variable "enable_suffix" {
  description = "Boolean to toggle suffixes for resources."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources that support tagging"
  type        = map(string)
  default     = {}
}