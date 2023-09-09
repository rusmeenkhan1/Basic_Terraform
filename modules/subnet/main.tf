


resource "aws_subnet" "Primary_subnet" {
 vpc_id = var.vpc_id
 cidr_block = var.subnet_cidr

 tags = {
   Name = "Primary_subnet"
   description = "main subnet for demo project"
 }
  
}


resource "aws_internet_gateway" "primary" {
  vpc_id = var.vpc_id

  tags = {
    Name = "Primary"
  }
}


resource "aws_route_table" "primary_route_table" {
  vpc_id = var.vpc_id
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
