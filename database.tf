# DB Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-main"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "main" {
  identifier              = "${var.environment}-main-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_encrypted       = true
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.database.id]
  multi_az                = false
  backup_retention_period = 7
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name        = "${var.environment}-main-db"
    Environment = var.environment
  }
}