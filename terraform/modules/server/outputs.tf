output "jenkins_master_public_ip" {
  description = "The public IP address of the Jenkins Master instance."
  value       = aws_instance.jenkins_master.public_ip
}

output "jenkins_master_private_ip" {
  description = "The private IP address of the Jenkins Master instance."
  value       = aws_instance.jenkins_master.private_ip
}

output "jenkins_slave_private_ip" {
  description = "The private IP address of the Jenkins Slave instance."
  value       = aws_instance.jenkins_slave.private_ip
}
