# ============================================================
# SG A — Vote + Result (public-facing)
# ============================================================
resource "aws_security_group" "vote_result" {
  name        = "${var.project}-vote-result-sg"
  description = "Allow HTTP from internet; SSH for bastion access"
  vpc_id      = aws_vpc.main.id

  # Vote app (port 5000) and Result app (port 80) from anywhere
  ingress {
    description = "HTTP - Result app"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Vote app port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH - bastion access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Tighten to your IP in production
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-vote-result-sg"
  })
}

# ============================================================
# SG B — Redis + Worker
# ============================================================
resource "aws_security_group" "redis_worker" {
  name        = "${var.project}-redis-worker-sg"
  description = "Allow Redis from Instance A; allow Worker to reach Postgres"
  vpc_id      = aws_vpc.main.id

  # Redis port — only from Instance A's SG
  ingress {
    description     = "Redis from Vote/Result"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.vote_result.id]
  }

  # SSH from Instance A (bastion hop)
  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.vote_result.id]
  }

  egress {
    description = "All outbound (Worker needs to reach Postgres + internet for Docker pull)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-redis-worker-sg"
  })
}

# ============================================================
# SG C — PostgreSQL
# ============================================================
resource "aws_security_group" "postgres" {
  name        = "${var.project}-postgres-sg"
  description = "Allow Postgres only from Worker SG"
  vpc_id      = aws_vpc.main.id

  # Postgres port — only from Instance B's SG (Worker)
  ingress {
    description     = "Postgres from Worker"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.redis_worker.id]
  }

  # Also allow Result app to query Postgres directly if needed
  ingress {
    description     = "Postgres from Result app"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.vote_result.id]
  }

  # SSH from Instance A (bastion hop)
  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.vote_result.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-postgres-sg"
  })
}
