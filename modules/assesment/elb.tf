# Create a new load balancer
resource "aws_elb" "elb" {
  name            = "${var.environment}-elb"
  subnets         =  aws_subnet.public.*.id
  security_groups = ["${aws_security_group.elb_sg.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 10
    target              = "HTTP:80/"
    interval            = 30
  }
  cross_zone_load_balancing = true

  tags = {
    Name = "${var.environment}-elb"
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "${var.environment}-elb-sg"
  description = "Allow incoming http traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
