################
# public subnet
################

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet_master" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet_master"
  }
}

resource "aws_subnet" "public_subnet_worker1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet_worker1"
  }
}

resource "aws_subnet" "public_subnet_worker2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = data.aws_availability_zones.available.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet_worker2"
  }
}



