resource "aws_security_group" "elb_sg" {
  name		= "terrafrom-ELB-SG"

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


