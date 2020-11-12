resource "aws_security_group" "elb_sg" {
  name		= "terraform-ELB-SG"

  ingress {
  from_port 	= 80
  to_port   	= 80
  protocol  	= "tcp"
  cidr_blocks	= ["${var.my_host}"]
  }

  egress {
  from_port	= 0
  to_port	= 0
  protocol	= "-1"
  cidr_blocks   = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "to_instance" {
  name 	           = "Terraform-ELB-ASG"
 
  ingress {
  from_port	   = 0
  to_port 	   = 0
  protocol	   = "-1"
  security_groups  = ["${aws_security_group.elb_sg.id}"]
  }
 
  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks	   = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "instance" {
  name 		= "terraform-example"

  ingress {
  from_port   	= var.server_port
  to_port       = var.server_port
  protocol      = "tcp"
  cidr_blocks   = [var.my_host]
  }
 
  lifecycle {
    create_before_destroy = true
  }
}

