output "ec2_public_ip" {
  value = aws_instance.nginx_server.public_ip
}