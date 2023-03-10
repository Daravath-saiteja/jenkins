provider "aws" {
  region = "eu-west-2"
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = tls_private_key.example.public_key_openssh
}
# resource "aws_key_pair" "my_key" {
#   key_name   = "my_key"
#   # public_key = file("~/.ssh/my_key.pub")
#   public_key = file("$/home/daravathsaiteja3/.ssh/my_key.pub")
# }
resource "aws_security_group" "ssh-access" {
  name_prefix = "ssh-access-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "example" {
  ami           = "ami-09ee0944866c73f62"  # The ID of the Amazon Machine Image (AMI) to use
  instance_type = "t2.micro"              # The instance type
  subnet_id     = "subnet-03a399803c7c6794d"  # The ID of the subnet to launch the instance in
  key_name = aws_key_pair.example.key_name
  security_groups = [aws_security_group.ssh-access.id]

  provisioner "file" {
    source = "./playbook.yml"
    destination = "/tmp/playbook.yml"
  }
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "~/.ssh/example-key.pem"
    host        = self.public_ip
    } 

    tags = {
    Name = "example-instance"
  }

}

resource "null_resource" "ansible-provisioner" {
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "~/.ssh/example-key.pem"
    host        = aws_instance.example.public_ip
  } 
  provisioner "file" {
    source = "./playbook.yml"
    destination = "/tmp/playbook.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y ansible",
      "ansible-playbook /tmp/playbook.yml"
    ]
  }
}


#Need to work on ansible 
  # user_data = <<-EOF
  #             #!/bin/bash
  #             apt-get update
  #             apt-get install -y ansible
  #             EOF

  # provisioner "remote-exec" {
  #   command = "ansible-playbook playbook.yml -i '${self.public_ip},' -u ec2-user --private-key ~/.ssh/example-key.pem"
  # }

         




