variable "namespace" {
  type        = string
  description = "Namespace for the resources."
  default     = "test"
}

variable "profile" {
  type        = string
  description = "AWS Config profile"
  default     = "default"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

################################################################
## networking
################################################################
variable "availability_zones" {
  description = "List of availability zones to deploy resources in."
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC to use."
  default     = "10.133.0.0/19"
}

variable "generate_ssh_key" {
  type        = bool
  description = "Whether or not to generate an SSH key"
  default     = true
}

variable "ssh_key_path" {
  type        = string
  description = "Save location for ssh public keys generated by the module"
  default     = "./secrets"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}


variable "tags" {
default = {a = "b"}
}
