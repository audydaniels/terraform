resource "aws_security_group" "elb_sg" {
  name		= "terrafrom-ELB-SG"

  ingress {
  from_port 	= 80
  to_port   	= 80
  protocol  	= "tcp"
  cidr_blocks	= ["${var.my_host}"]
  }
}


