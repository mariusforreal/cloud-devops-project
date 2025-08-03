output "jenkins_master_public_ip" {
  description = "The public IP address of the Jenkins Master."
  value       = module.server.jenkins_master_public_ip
}

output "jenkins_master_private_ip" {
  description = "The private IP address of the Jenkins Master."
  value       = module.server.jenkins_master_private_ip
}

output "jenkins_slave_private_ip" {
  description = "The private IP address of the Jenkins Slave."
  value       = module.server.jenkins_slave_private_ip
}

output "public_subnet_id" {
  description = "ID of the public subnet where Jenkins Master resides."
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet where Jenkins Slave resides."
  value       = module.network.private_subnet_id
}
