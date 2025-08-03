# جلب معلومات الـAvailability Zones المتاحة في الـRegion
data "aws_availability_zones" "available" {
  state = "available"
}

# --- VPC (Virtual Private Cloud) ---
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "${var.project_name}-VPC"
    Project = var.project_name
  }
}

# --- Public Subnet (لـJenkins Master) ---
# هنستخدم أول Availability Zone متاحة للـMaster
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0] # أول AZ
  map_public_ip_on_launch = true # عشان الـMaster ياخد Public IP

  tags = {
    Name    = "${var.project_name}-PublicSubnet-AZ1"
    Project = var.project_name
  }
}

# --- Private Subnet (لـJenkins Slave) ---
# هنستخدم تاني Availability Zone متاحة للـSlave (لتحقيق HA)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[1] # تاني AZ
  
  tags = {
    Name    = "${var.project_name}-PrivateSubnet-AZ2"
    Project = var.project_name
  }
}

# --- Internet Gateway (للوصول للـInternet من الـPublic Subnet) ---
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-IGW"
    Project = var.project_name
  }
}

# --- NAT Gateway (للسماح للـPrivate Subnet بالوصول للـInternet) ---
# هنحط الـNAT Gateway في الـPublic Subnet
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  tags = {
    Name    = "${var.project_name}-NATGatewayEIP"
    Project = var.project_name
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public.id # الـNAT Gateway في الـPublic Subnet

  tags = {
    Name    = "${var.project_name}-NATGateway"
    Project = var.project_name
  }

  depends_on = [aws_internet_gateway.main]
}

# --- Route Table للـPublic Subnet ---
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-PublicRouteTable"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# --- Route Table للـPrivate Subnet ---
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-PrivateRouteTable"
    Project = var.project_name
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
