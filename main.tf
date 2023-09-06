
provider aws {
  region = "ap-south-1"
}

variable "cidr_block" {
  description = "cidr for vpc"
 
  # if no value is passed then it will create with default value

  default = {cidr:"10.0.0.0/16",name:"default"}
}


resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block.cidr
  
  tags = {
    Name = var.cidr_block.name
  }
}


