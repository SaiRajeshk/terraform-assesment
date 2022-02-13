data "template_file" "init" {
  template = file("${path.module}/script-init.sh.tpl")
}

resource "aws_key_pair" "dev" {
  key_name   = "${var.environment}-key"
  public_key = var.public_key
}

resource "aws_autoscaling_group" "ec2" {
  name     = "${var.environment}-asg"
  max_size = 3
  min_size = 1

  # desired_capacity          = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.elb.name}"]
  force_delete              = true
  vpc_zone_identifier       = aws_subnet.public.*.id
  launch_configuration      = aws_launch_configuration.ec2.id
}


resource "aws_launch_configuration" "ec2" {
  image_id        = var.ami_name
  instance_type   = var.instance_type
  key_name        = aws_key_pair.dev.key_name
  user_data       = data.template_file.init.rendered
  security_groups = ["${aws_security_group.sg.id}"]
}

resource "aws_autoscaling_policy" "ScaleupPolicy" {
  name                   = "Scaleup"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2.name
}

resource "aws_autoscaling_policy" "ScaleDownPolicy" {
  name                   = "ScaleDown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ec2.name
}

resource "aws_cloudwatch_metric_alarm" "ScaleupPolicy" {
  alarm_name          = "${var.environment}-ec2-scaleup"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.ec2.name}"
  }

  alarm_description = "monitoring ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.ScaleupPolicy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ScaleDownPolicy" {
  alarm_name          = "${var.environment}-ec2-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.ec2.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.ScaleDownPolicy.arn}"]
}
