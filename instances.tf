

##################
# Master Node
##################

resource "aws_instance" "master_node" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  availability_zone      = "ap-northeast-2a"
  subnet_id              = aws_subnet.public_subnet_public_master
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.master_sg.id]
  private_ip             = "10.0.2.10"    

  user_data = filebase64("master.sh")

  tags = { Name = "k8s-master" }

}


###################
# Worker node
###################

resource "aws_instance" "node_1" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  availability_zone      = "ap-northeast-2a"
  subnet_id              = aws_subnet.public_subnet_worker1
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.worker_sg.id]
  private_ip             = "10.0.4.10"

  user_data = filebase64("worker1.sh")

  tags = { Name = "k8s-worker1" }
}

resource "aws_instance" "node_2" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  availability_zone      = "ap-northeast-2c"
  subnet_id              = aws_subnet.public_subnet_worker2
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.worker_sg.id]
  private_ip             = "10.0.5.10"

  user_data = filebase64("worker2.sh")

  tags = { Name = "k8s-worker2" }
}