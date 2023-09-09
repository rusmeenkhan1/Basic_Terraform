

resource "aws_key_pair" "nginx_server_key" {
  key_name   = "nginx_server_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCMDuvDMLzBBfOEBFR9AC5zS5uuZm0uuBGAd0QLcaL3ZHuQP7igrqdnSC0B2Uuz/oc1qmHYX9yLNlaIBprs94ReEQkg8gT1uN5r0L+avQbIlMszWOhmwGlDF85pNimSDJj4cq/MkjmOkyNhLYe7kUMELZKUEt4Q2sJyPY7qxRgX7WMbGG8pmzGg36D9TA8OUXovo8Cc5B6bG/EzMEg+gDV76iV76tPjZMvrGIFLX4CjG5IFUdFPveRQeTUqBcTS5JMsSSM7fFBiMg34bvkYcIZRG2M61qGw3DX9Ipv6n/h7rmzcw/rDA0iuROVmVeAe7+lMLfWtJ4Sq/EAq1Rb9X7uJlwY0Dn0xT/pXCyObylUykuZUb7IbyEdBiuidhT2j68BST/k2FjEVKvVa0EPE1QGAdIfbviMNXmbk8BOZQQU8H5lEukv+E2mM/bQ9f4UUmTuMsp4BtWlvmMH+KOqcO3E21lnMbAXSJkxI/rC/p4kR1eO+qBsUekfL8rI2VUAUXc= rusmeen.khan@mac-HVJQKCWPDX"
}

resource "aws_security_group" "ssh_sg" {
    vpc_id = var.vpc_id
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
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  key_name = aws_key_pair.nginx_server_key.key_name
  vpc_security_group_ids = ["${aws_security_group.ssh_sg.id}"]
  #security_groups = [aws_security_group.ssh_sg.name]
  tags = {
    Name = "nginx_server"
    description = "Ec2 server for demo project"
  }
}