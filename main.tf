cat << 'EOF' > main.tf
provider "aws" {
    region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
    name        = "ansible-security-sg"
    description = "Allow SSH access"

    ingress {
        from_port   = 22
        to_port     = 22
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

resource "aws_instance" "web_server" {
    ami                    = "ami-004f790b835b26145"
    instance_type          = "t3.micro"
    key_name               = "kamo"
    vpc_security_group_ids = [aws_security_group.web_sg.id]

    tags = {
        Name = "Security-Target-Server"
        Role = "webserver"
    }
}
EOF
