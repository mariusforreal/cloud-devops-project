variable "project_name" {
  description = "اسم المشروع للـtagging."
  type        = string
}

variable "key_pair_name" {
  description = "اسم الـKey Pair للدخول على الـEC2 instances."
  type        = string
}

variable "ami_id" {
  description = "الـAMI ID لإنشاء الـEC2 instances."
  type        = string
}

variable "master_instance_type" {
  description = "نوع الـEC2 instance للـJenkins Master."
  type        = string
}

variable "slave_instance_type" {
  description = "نوع الـEC2 instance للـJenkins Slave."
  type        = string
}

variable "vpc_id" {
  description = "الـID بتاع الـVPC."
  type        = string
}

variable "public_subnet_id" {
  description = "الـID بتاع الـpublic subnet."
  type        = string
}

variable "private_subnet_id" {
  description = "الـID بتاع الـprivate subnet."
  type        = string
}
