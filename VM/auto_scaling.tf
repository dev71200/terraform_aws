data "aws_availability_zones" "all" {}

resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}
resource "aws_elb" "test" {
  name               = "test-lb-tf"
  internal           = false
#  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = [var.subnet_id_1, var.subnet_id_2]
  listener {
    instance_port     = 80
    instance_protocol = "TCP"
    lb_port           = 80
    lb_protocol       = "TCP"
  }
}
data "aws_elb" "lb_id" {
  depends_on = [aws_elb.test]
  name = aws_elb.test.name
}


resource "aws_launch_configuration" "example" {
  image_id               = "ami-0630b1173268761b7"
  instance_type          = "t2.micro"
  security_groups        = ["${var.sg_id}"]
  key_name               = "automate-demo"
  associate_public_ip_address = "true"
  lifecycle {
    create_before_destroy = true
  }


  
  
}
##Scale-Out Policy
resource "aws_autoscaling_policy" "terraform-test" {
  name                   = "terraform-test"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.example.name 
}
##Cloudwatch Metric for Scale-OUT
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_up" {
  alarm_name = "cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "70"

  dimensions = {
    autoscaling_group_name = aws_autoscaling_group.example.name
  }
  alarm_description = "this is for  ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.terraform-test.arn]
  
}
##Scale-IN Policy
resource "aws_autoscaling_policy" "terraform-test-2" {
  name                   = "terraform-test-2"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.example.name
}
##Cloudwatch Metric for Scale-OUT
resource "aws_cloudwatch_metric_alarm" "cpu_alarm_down" {
  alarm_name = "cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "20"
dimensions = {
    autoscaling_group_name = aws_autoscaling_group.example.name
  }
  alarm_description = "this is for  ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.terraform-test-2.arn]
} 
## Creating AutoScaling Group
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  vpc_zone_identifier = [var.subnet_id_1, var.subnet_id_2]
  min_size = 2
  max_size = 6
  health_check_grace_period = 60
  load_balancers = ["${data.aws_elb.lb_id.id}"]
  health_check_type = "ELB"
}
