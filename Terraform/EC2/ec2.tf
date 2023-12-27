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
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt install -y curl
    curl -fsSL https://deb.nodesource.com/setup-20.x | sudo -E bash -
    sudo apt install -y nodejs
    sudo npm install pm2 -g
    sudo apt install apache2 -y
    git config --global credential.helper store
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
  name = var.security_group_name
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

  egress {
    from_port   = 0 # Allow traffic from all ports
    to_port     = 0 # Allow traffic to all ports
    protocol    = "-1" # Allow all protocols (TCP, UDP, ICMP)
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound traffic to anywhere
  }

  tags = {
    Name = var.security_group_name
  }
}
