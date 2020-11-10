provider "aws" {
  region = "us-east-2"
}
variable "server_port" {
  description = "The port the server will use for HTTP requestes"
  default     = 8080
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"
}
resource "aws_instance" "example" {
  ami 		= "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  user_data = <<-EOF
	      #!/bin/bash
	      echo "HEllo, World"> index.html
     	      nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags = {
    name = "terraform-example-version2"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example"
  
  ingress {
    from_port	 = "${var.server_port}"
    to_port      = "${var.server_port}"
    protocol  	 = "tcp"
    cidr_blocks = ["108.90.7.137/32"]
  }
  lifecycle { 
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-0a91cd140a1fc148a"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  user_data       = <<-EOF
  		    #!/bin/bash
   		    echo "Hello, World"> index.html
  		    nohup busybox httpd -f -p "${var.server_port}" &
  		    EOF
  lifecycle {
    create_before_destroy = true 
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  
  min_size = 2
  max_size = 10
  
  tag {
    key 		= "Name"
    value 		= "terraform-asg-example"
    propagate_at_launch = true
  }
}


