
provider aws {
  region = "ap-south-1"
}

variable "cidr_block" {
  description = "cidr for vpc"
}


resource "aws_vpc" "dev_vpc" {
  cidr_block = var.cidr_block
  
  tags = {
    Name = "vpc_1"
  }
}
