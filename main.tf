
provider aws{
    region = "ap-south-1"
}


variable "cidr_block_main" {
  description = "cidr block for main vpc"
}

resource "aws_vpc" "main"{
   
   # define value directly 
   #cidr_block = "10.100.0.0/16"

   # passing value on runtime by using varible name
   cidr_block = var.cidr_block_main

   # we can pass variable with apply  command using -var and variable name and value
   # ex: terraform apply -var "cidr_block_main=10.100.0.0/16" 

   # best way is to use terraform.tfvars
   # if we have given any other name apart from terraform.tfvars then we need to pass that file path
   # using teraform apply -var-file pathToFile

   tags = {
     Name = "first vpc"
   }
}

resource "aws_subnet" "dev" {

  # we can directly pass value or we can refer to existing vpc
  #vpc_id = "10.100.0.0/16"


  # getting id of existing vpc
  vpc_id = aws_vpc.main.id
  cidr_block = "10.100.0.0/16"

  tags = {
    Name = "dev subnet"
  }
}


# creating a resource from already existing resource that is not in tf file we use data 

# to get details of default vpc . we can use data module and pass default as true 
data "aws_vpc" "default_vpc"{
    default = true
}


resource "aws_subnet" "default_subnet" {

    vpc_id = data.aws_vpc.default_vpc.id
    cidr_block = "172.31.0.0/20"
  tags = {
    Name = "default subnet"
  }
}

# used for printing output the attributes  to console of resource created 
output "default_subnet_id" {
  value = aws_subnet.default_subnet.id
}
