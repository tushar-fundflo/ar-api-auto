# Create an IAM role for the EC2 instance
resource "aws_iam_role" "instance_role" {
  name = var.instance_role_name
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach an IAM policy to the role (if needed)
resource "aws_iam_policy_attachment" "policy_attachment_1" {
  name       = "S3FullAccess"
  roles      = [aws_iam_role.instance_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_policy_attachment" "policy_attachment_2" {
  name       = "CloudWatchFullAccess"
  roles      = [aws_iam_role.instance_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
resource "aws_iam_policy_attachment" "policy_attachment_3" {
  name       = "CloudWatchFullAccessV2"
  roles      = [aws_iam_role.instance_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccessV2"
}
resource "aws_iam_policy_attachment" "policy_attachment_4" {
  name       = "AmazonSQSFullAccess"
  roles      = [aws_iam_role.instance_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}
# Create an IAM instance profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_role_name
  role = aws_iam_role.instance_role.name
}