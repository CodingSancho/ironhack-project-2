# Instance A — Vote + Result (public subnet, bastion)
resource "aws_instance" "instance_a" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.vote_result.id]

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

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-instance-c-postgres"
    Role = "database"
  })
}
