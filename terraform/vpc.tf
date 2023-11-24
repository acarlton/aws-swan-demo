resource "aws_vpc" "vpc" {
  cidr_block           = "10.${var.vpc_cidr_index}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = local.namespace
  }
}

# Public subnets
resource "aws_subnet" "public_1" {
  availability_zone       = "${var.aws_region}a"
  cidr_block              = "10.${var.vpc_cidr_index}.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_2" {
  availability_zone       = "${var.aws_region}b"
  cidr_block              = "10.${var.vpc_cidr_index}.2.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name = "Public Subnet 2"
  }
}

# Private subnets
resource "aws_subnet" "private_1" {
  availability_zone = "${var.aws_region}a"
  cidr_block        = "10.${var.vpc_cidr_index}.3.0/24"
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private_2" {
  availability_zone = "${var.aws_region}b"
  cidr_block        = "10.${var.vpc_cidr_index}.4.0/24"
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "Private Subnet 2"
  }
}

# Create an internet gateway for public access
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.namespace
  }
}

# Route requests for public traffic through the internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "${local.namespace}-public"
  }
}

# Assign the public subnets to the public route table
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Create a NAT gateway to allow private subnets access to external requests
resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = local.namespace
  }
}

# Route table for requests for public traffic through the NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway.id
  }

  tags = {
    Name = "${local.namespace}-private"
  }
}

# Assign the private subnets to the private route table
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
