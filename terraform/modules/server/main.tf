# --- Security Group للـJenkins Master ---
resource "aws_security_group" "jenkins_master_sg" {
  name        = "${var.project_name}-JenkinsMaster-SG"
  description = "Security Group for Jenkins Master"
  vpc_id      = var.vpc_id

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # يفضل تقييد الـIPs هنا لأمان أعلى
  }

  # Jenkins UI Access
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # يفضل تقييد الـIPs هنا لأمان أعلى
  }

  # Outbound access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-JenkinsMaster-SG"
    Project = var.project_name
  }
}

# --- Security Group للـJenkins Slave ---
resource "aws_security_group" "jenkins_slave_sg" {
  name        = "${var.project_name}-JenkinsSlave-SG"
  description = "Security Group for Jenkins Slave"
  vpc_id      = var.vpc_id

  # SSH Access from Jenkins Master SG only
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_master_sg.id]
  }

  # JNLP Access from Jenkins Master SG only (Jenkins Agent Protocol)
  ingress {
    from_port       = 50000
    to_port         = 50000
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_master_sg.id]
  }

  # Outbound access to anywhere (through NAT Gateway)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-JenkinsSlave-SG"
    Project = var.project_name
  }
}

# --- Jenkins Master EC2 Instance ---
resource "aws_instance" "jenkins_master" {
  ami                         = var.ami_id
  instance_type               = var.master_instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.public_subnet_id # في الـPublic Subnet
  associate_public_ip_address = true                       # عشان ياخد Public IP
  vpc_security_group_ids      = [aws_security_group.jenkins_master_sg.id]

  tags = {
    Name    = "${var.project_name}-Jenkins-Master" # تسمية الماستر
    Role    = "Jenkins-Master"
    Project = var.project_name
  }
}

# --- Jenkins Slave EC2 Instance ---
resource "aws_instance" "jenkins_slave" {
  ami                         = var.ami_id
  instance_type               = var.slave_instance_type
  key_name                    = var.key_pair_name
  subnet_id                   = var.private_subnet_id # في الـPrivate Subnet
  associate_public_ip_address = false                        # مش محتاج Public IP
  vpc_security_group_ids      = [aws_security_group.jenkins_slave_sg.id]

  tags = {
    Name    = "${var.project_name}-Jenkins-Slave-01" # تسمية السليف
    Role    = "Jenkins-Slave"
    Project = var.project_name
  }
}
