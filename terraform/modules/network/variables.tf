variable "project_name" {
  description = "اسم المشروع للـtagging."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block للـVPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block للـpublic subnet."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block للـprivate subnet."
  type        = string
}
