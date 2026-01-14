provider "aws" {
  region = var.region
}

resource "aws_instance" "task_ec2" {
  ami           = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.task_sg.id]

  tags = {
    Name = "task-tracker"
  }
}

resource "aws_security_group" "task_sg" {
  name = "task-tracker-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
