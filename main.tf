data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "my-key-pair" {
  key_name   = "my-key-pair"
  public_key = "${file("~/.ssh/my-key-pair.pub")}"
}

resource "aws_instance" "vm" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "my-awesome-vm"
  }

  vpc_security_group_ids = [aws_security_group.sg.id]
  
  lifecycle {
     create_before_destroy = true
  }
  
  key_name      = aws_key_pair.example_keypair.key_name

  connection {
  type = "ssh"
  user = "ec2-user"
  private_key = "${file("~/.ssh/my-key-pair.pub")}"
  host = self.public_ip
  }
}


resource "aws_security_group" "sg" {
  name_prefix = "my-security-group"
  description = "Security group for my VM"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value = aws_instance.vm.public_ip
}
