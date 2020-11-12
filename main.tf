provider "aws" {
  region = var.aws_region
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
    name = "solo-terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example"
  
  ingress {
    from_port	 = var.server_port
    to_port      = var.server_port
    protocol  	 = "tcp"
    cidr_blocks = [var.my_host]
  }
  lifecycle { 
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "example" {
  image_id        = "ami-0a91cd140a1fc148a"
  instance_type   = "t2.micro"
  security_groups  = ["${aws_security_group.instance.id}"]
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
  availability_zones   = "${data.aws_availability_zones.all.zone_ids}"  
  
  load_balancers       = ["${aws_elb.example.id}"]  
  health_check_type    = "ELB" #This tells the ASG to use the ELB's health check to determine if instance is healthy

  min_size = 2
  max_size = 10
  
  tag {
    key 		= "Name"
    value 		= "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_elb" "example" {
  name		     = "terraform-asg-example"
  availability_zones = "${data.aws_availability_zones.all.zone_ids}"
  security_groups    = ["{aws_security_group.elb_sg.id}"]
  
  listener {
    lb_port 		= "${var.elb_port}"
    lb_protocol 	= "http"
    instance_port	= "${var.server_port}"
    instance_protocol   = "http"
  }  
  
  health_check {
    healthy_threshold	= 2
    unhealthy_threshold = 2
    timeout 		= 3 
    interval		= 30
    target 		= "HTTP:${var.server_port}/"
  }
  

}


