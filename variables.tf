terraform {
  experiments = [module_variable_optional_attrs]
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "subnets" {
  type = list(object({
    cidr_block  = string
    zone        = optional(string)
    public      = bool
    nat_gateway = optional(bool)
  }))
  default = []
}

variable "secondary_cidr_blocks" {
  type    = list(string)
  default = []
}