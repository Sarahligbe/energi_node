variable "name" {
  description = "Base name for the IAM resources."
  type        = string
}

variable "add_suffix" {
  description = "Boolean to toggle suffixes for resources."
  type        = bool
  default     = true
}