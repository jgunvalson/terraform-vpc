resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "subnets" {
  count = length(var.subnets)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnets[count.index].cidr_block
  map_public_ip_on_launch = var.subnets[count.index].public
  availability_zone       = var.subnets[count.index].zone != null ? var.subnets[count.index].zone : null

  tags = {
    Name = "${var.name}-${count.index}"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr_blocks" {
  count = length(var.secondary_cidr_blocks)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.secondary_cidr_blocks[count.index]
}

data "aws_internet_gateway" "default-internet-gateway" {
  filter {
    name   = "attachment.vpc-id"
    values = [aws_vpc.vpc.id]
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default-internet-gateway.id
  }

  tags = {
    Name = "${var.name}-route-table"
  }
}