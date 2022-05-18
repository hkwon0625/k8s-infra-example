
####################
# public route table
####################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public rt"
  }
}

resource "aws_route" "public_rtb" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rt_master" {
  subnet_id      = aws_subnet.public_subnet_master
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "public_rt_worker1" {
  subnet_id      = aws_subnet.public_subnet_worker1
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_worker2" {
  subnet_id      = aws_subnet.public_subnet_worker2
  route_table_id = aws_route_table.public_rt.id
}



