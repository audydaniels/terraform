provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami 		= "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  user_data = <<-EOF
	      #!/bin/bash
	      echo "HEllo, World"> index.html
     	      nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    name = "terraform-example.2.2"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example"
  
  ingress {
    from_port	 = 8080
    to_port      = 8080
    protocol  	 = "tcp"
    cidr_blocks = ["108.90.7.137/32"]
  } 
}
