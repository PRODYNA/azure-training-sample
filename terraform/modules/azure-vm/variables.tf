variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to use"
}

variable "instance_id" {
  type        = string
  description = "ID of instance"
}

variable "subnet_id" {
  type        = string
  description = "ID of subnet"
}

variable "pip_id" {
  type        = string
  description = "ID of public IP"
}

variable "asg_id" {
  type        = string
  description = "ID of ASG"
}
