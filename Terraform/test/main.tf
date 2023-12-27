resource "aws_eip_association" "api_server_eip" {
  instance_id = "i-03689e72c6c44d6bd"
  allocation_id = "eipalloc-06d9efbb8d9be4e1d"
}
