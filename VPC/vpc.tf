resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "customVPC" {
  cidr_block       = "10.0.0.0/26"
  instance_tenancy = "default"

  tags = {
    Name = "MyCustomVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "MyIGW"
  }
}

resource "aws_route" "routeIGW" {
  route_table_id            = aws_vpc.customVPC.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

resource "aws_subnet" "pub-a" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.0/28"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Public - a"
  }
}

resource "aws_subnet" "pub-b" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.16/28"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Public - b"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.pub-a.id
  route_table_id = aws_vpc.customVPC.main_route_table_id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.pub-b.id
  route_table_id = aws_vpc.customVPC.main_route_table_id
}
