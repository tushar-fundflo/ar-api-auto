# Create the EC2 instance
resource "aws_instance" "api_server" {
  ami             = var.ec2_ami
  instance_type   = var.ec2_type
  key_name        = var.key_name
  subnet_id       = var.ec2_subnet_id
  # Instance Bootup
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from user data script!"
    # Add additional commands or configurations here
  EOF
  # END
  vpc_security_group_ids = [aws_security_group.api_server_sg.id]
  iam_instance_profile = var.instance_profile
  associate_public_ip_address = false
  tags = {
    Name = var.ec2_name
  }
}
resource "aws_eip_association" "api_server_eip" {
  instance_id = aws_instance.api_server.id
  allocation_id = var.allocation_id
}

# Create a security group
resource "aws_security_group" "api_server_sg" {
  vpc_id = var.vpc_id

  # Define your security group rules here
  # Example: Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Example: Allow HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}
