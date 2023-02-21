provider "aws" {
  region = "eu-west-2"
  shared_config_files = ["/home/daravathsaiteja3/.aws/config"]
  shared_credentials_files = ["/home/daravathsaiteja3/.aws/credentials"]
}

resource "aws_instance" "example" {
  ami           = "ami-09ee0944866c73f62"  # The ID of the Amazon Machine Image (AMI) to use
  instance_type = "t2.micro"              # The instance type
  subnet_id     = "subnet-03a399803c7c6794d"  # The ID of the subnet to launch the instance in


  tags = {
    Name = "example-instance"
  }
}
