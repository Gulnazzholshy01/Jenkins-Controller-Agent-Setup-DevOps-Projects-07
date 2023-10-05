resource "aws_instance" "jenkins_master" {
  ami                    = data.aws_ami.jenkins_master_ami.id
  instance_type          = var.master_instance_type
  subnet_id              = data.aws_subnets.us-east-1_default_subnets.ids[1]
  vpc_security_group_ids = [aws_security_group.jenkins_master_sg.id]
  key_name               = var.key_name


  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.master_root_volume_size
    delete_on_termination = true
  }
  tags = merge({
    Name = "${var.master_instance_name}" },
    local.common_tags
  )
}

resource "aws_security_group" "jenkins_master_sg" {
  name        = "jenkins_master_sg"
  description = "Allow traffic on port 8080 and enable SSH"
  vpc_id      = data.aws_vpc.default_vpc.id
  tags = merge({
    Name = "jenkins-master-sg" },
    local.common_tags
  )
}


resource "aws_security_group_rule" "ingress22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.port22_ips
  security_group_id = aws_security_group.jenkins_master_sg.id
}

resource "aws_security_group_rule" "ingress80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.https_cidr
  security_group_id = aws_security_group.jenkins_master_sg.id
}


resource "aws_security_group_rule" "ingress443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.https_cidr
  security_group_id = aws_security_group.jenkins_master_sg.id
}


resource "aws_security_group_rule" "ingress8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_master_sg.id
}


resource "aws_security_group_rule" "engress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_master_sg.id
}


