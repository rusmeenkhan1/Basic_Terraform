
resource "aws_vpc" "primary" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "Primary"
    description = "main vpc for demo project"
  }
}

module "primary_subnet" {
  source = "./modules/subnet"
  vpc_id = aws_vpc.primary.id
  subnet_cidr = var.subnet_cidr

}

module "nginx_server" {
  source = "./modules/nginx_server"
  ami = var.ami
  instance_type = var.instance_type
  vpc_id = aws_vpc.primary.id
  subnet_id = module.primary_subnet.subnet_id.id
}

resource "aws_instance" "demo" {
  # (resource arguments)
 ami = "ami-067c21fb1979f0b27"
 instance_type = "t3.micro"
}

resource "aws_instance" "test" {
  # (resource arguments)
 ami = "ami-067c21fb1979f0b27"
 instance_type = "t3.micro"
 tags = {
     "Name": "test"
 }
}