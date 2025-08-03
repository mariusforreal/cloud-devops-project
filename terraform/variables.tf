variable "project_name" {
  description = "اسم المشروع للـtagging."
  type        = string
  default     = "CloudDevOpsProject"
}

variable "aws_region" {
  description = "الـAWS Region اللي هيتم فيها الـDeployment."
  type        = string
  default     = "us-east-1" # **مهم: لازم دي تتطابق مع الـregion في providers.tf**
}

variable "key_pair_name" {
  description = "اسم الـKey Pair للدخول على الـEC2 instances."
  type        = string
  # **مهم جداً: غير دي لاسم الـKey Pair بتاعك الموجود في AWS**
  default     = "CloudDevOpsProject-keypair"
}

variable "ami_id" {
  description = "الـAMI ID لإنشاء الـEC2 instances (Ubuntu 22.04 LTS recommended)."
  type        = string
  # **مهم جداً: غير دي لـAMI ID صحيح لمنطقتك ونظام التشغيل اللي هتستخدمه**
  # تقدر تلاقيه في AWS EC2 Console أو تستخدم data source
  default     = "ami-0cbbe2c6a1bb2ad63"
}

variable "master_instance_type" {
  description = "نوع الـEC2 instance للـJenkins Master."
  type        = string
  default     = "t2.medium"
}

variable "slave_instance_type" {
  description = "نوع الـEC2 instance للـJenkins Slave."
  type        = string
  default     = "t2.medium"
}
