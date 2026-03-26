
provider "aws" {
region = "ap-south-1"
}

resource "aws_instance" "myvm" {
  ami           = "ami-0ffef61f6dc37ae89"
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}
