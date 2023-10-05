resource "aws_launch_template" "jenkins_workers_launch_template" {
  name          = "lt-jenkins-workers"
  image_id      = data.aws_ami.jenkins_worker_ami.id
  instance_type = var.worker_instance_type
  key_name      = var.key_name
  user_data     = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }


  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.jenkins_workers_sg.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_type           = "gp2"
      volume_size           = var.worker_root_volume_size
      delete_on_termination = true
      encrypted             = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "jenkins_workers" {
  name                = "jenkins_workers_asg"
  vpc_zone_identifier = data.aws_subnets.us-east-1_default_subnets.ids
  min_size            = 1
  max_size            = 10

  launch_template {
    id      = aws_launch_template.jenkins_workers_launch_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }


  dynamic "tag" {
    for_each = local.common_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "jenkins-worker"
    propagate_at_launch = true
  }

  depends_on = [aws_instance.jenkins_master, aws_launch_template.jenkins_workers_launch_template]
}


resource "aws_security_group" "jenkins_workers_sg" {
  name        = "jenkins_workers_sg"
  description = "Allow traffic on port 22 from Jenkins master SG"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = var.port22_ips
    security_groups = [aws_security_group.jenkins_master_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
    Name = "jenkins-worker-sg" },
    local.common_tags
  )
}