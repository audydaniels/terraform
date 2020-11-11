variable "aws_region" {
  description = "Sets the AWS Region"
  default     = "us-east-2"
}

variable "server_port" {
  description = "Sets inbound port for webserver connection"
  default     = 8080
}

output "public_ip" {
  description = "Show public IP's on screen after apply"
  value       = "${aws_instance.example.public_ip}"
}





