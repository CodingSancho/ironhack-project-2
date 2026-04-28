# Instance A — Vote + Result (public subnet, bastion)
resource "aws_instance" "instance_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.vote_result.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_cloudwatch.name

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-instance-a-vote-result"
    Role = "frontend-bastion"
  })
}

# Elastic IP for Instance A — stable public IP across reboots
resource "aws_eip" "instance_a" {
  instance = aws_instance.instance_a.id
  domain   = "vpc"

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-instance-a-eip"
  })
}

# Instance B — Redis + Worker (private subnet)
resource "aws_instance" "instance_b" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_b.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.redis_worker.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_cloudwatch.name

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-instance-b-redis-worker"
    Role = "backend"
  })
}

# Instance C — PostgreSQL (private subnet)
resource "aws_instance" "instance_c" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_c.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.postgres.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_cloudwatch.name

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-instance-c-postgres"
    Role = "database"
  })
}

# ============================================================
# IAM Role — allows EC2 instances to push metrics/logs to CloudWatch
# ============================================================
resource "aws_iam_role" "ec2_cloudwatch" {
  name = "${local.prefix}-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-ec2-cloudwatch-role"
  })
}

# Attach AWS managed policy for CloudWatch Agent
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Instance profile — this is what you attach to EC2
resource "aws_iam_instance_profile" "ec2_cloudwatch" {
  name = "${local.prefix}-ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch.name
}
