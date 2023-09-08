
variable "vpc_cidr" {}
variable "subnet_cidr" {}
variable "ami" {}
variable "instance_type" {}

variable "private_key_path" {}

resource "aws_vpc" "primary" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Primary"
    description = "main vpc for demo project"
  }
}

resource "aws_subnet" "Primary_subnet" {
 vpc_id = aws_vpc.primary.id
 cidr_block = var.subnet_cidr

 tags = {
   Name = "Primary_subnet"
   description = "main subnet for demo project"
 }
  
}

resource "aws_key_pair" "nginx_server_key" {
  key_name   = "nginx_server_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMDuvDMLzBBfOEBFR9AC5zS5uuZm0uuBGAd0QLcaL3ZHuQP7igrqdnSC0B2Uuz/oc1qmHYX9yLNlaIBprs94ReEQkg8gT1uN5r0L+avQbIlMszWOhmwGlDF85pNimSDJj4cq/MkjmOkyNhLYe7kUMELZKUEt4Q2sJyPY7qxRgX7WMbGG8pmzGg36D9TA8OUXovo8Cc5B6bG/EzMEg+gDV76iV76tPjZMvrGIFLX4CjG5IFUdFPveRQeTUqBcTS5JMsSSM7fFBiMg34bvkYcIZRG2M61qGw3DX9Ipv6n/h7rmzcw/rDA0iuROVmVeAe7+lMLfWtJ4Sq/EAq1Rb9X7uJlwY0Dn0xT/pXCyObylUykuZUb7IbyEdBiuidhT2j68BST/k2FjEVKvVa0EPE1QGAdIfbviMNXmbk8BOZQQU8H5lEukv+E2mM/bQ9f4UUmTuMsp4BtWlvmMH+KOqcO3E21lnMbAXSJkxI/rC/p4kR1eO+qBsUekfL8rI2VUAUXc= rusmeen.khan@mac-HVJQKCWPDX"
}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "Primary"
  }
}



resource "aws_route_table" "primary_route_table" {
  vpc_id = aws_vpc.primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }
  tags = {
    Name = "Primary_route_table"
  }
}


resource "aws_route_table_association" "primary_route_table_primary_subnet" {
   subnet_id      = aws_subnet.Primary_subnet.id
   route_table_id = aws_route_table.primary_route_table.id
}


resource "aws_security_group" "ssh_sg" {
    vpc_id = aws_vpc.primary.id
    name = "ssh_sg"
    ingress {
        description      = "ssh from local"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["223.190.83.113/32"]
  }
      ingress {
        description      = "nginx ui"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "ssh_sg"
  }
}


resource "aws_instance" "nginx_server" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.Primary_subnet.id
  associate_public_ip_address = true
  key_name = aws_key_pair.nginx_server_key.key_name
  vpc_security_group_ids = ["${aws_security_group.ssh_sg.id}"]
  #security_groups = [aws_security_group.ssh_sg.name]
  tags = {
    Name = "nginx_server"
    description = "Ec2 server for demo project"
  }
  
  # this will run on local where terraform is running. Not on ec2
  # this will run after instance creation/resource creation
  provisioner "local-exec" {
    command = "echo 'local provisioner'"
    
  }

  connection  {
    type = "ssh"
    user = "ec2-user"
    host = self.public_ip
    private_key = file(var.private_key_path)
  }

  # this will run on ec2 that is newly created
  # this will run after instance creation/resource creation
  # for running remote provisioner we need to connect to vm using ssh
  provisioner "remote-exec" {
     
     # we can run using inline or direclty pass a file
     #inlinline = [ 
     #   "mkdir '/home/ec2-user/demo'"
      #]

    # it will run this script on remote server
    script = "start.sh"
  }
  

  # used for copying file or content from local to remote server
  provisioner "file" {

    source = "readme"
    destination = "/home/ec2-user/readme"

    
  }
}