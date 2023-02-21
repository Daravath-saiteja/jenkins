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

resource "aws_instance" "example" {
  ami           = "ami-09ee0944866c73f62"  # The ID of the Amazon Machine Image (AMI) to use
  instance_type = "t2.micro"              # The instance type
  subnet_id     = "subnet-03a399803c7c6794d"  # The ID of the subnet to launch the instance in
  key_name = aws_key_pair.example.key_name
 
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y ansible
              EOF

  # provisioner "local-exec" {
  #   command = "ansible-playbook playbook.yml -i '${self.public_ip},' -u ec2-user --private-key ~/.ssh/mykey.pem"
  # }
  provisioner "local-exec" {
    inline = [
      "ansible-playbook /jenkins-project/jenkins/playbook.yml/playbook.yml"
    ]
  }
         

  tags = {
    Name = "example-instance"
  }
}

