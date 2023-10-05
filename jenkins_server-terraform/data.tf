data "aws_ami" "jenkins_master_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-master*"]
  }
}


data "aws_ami" "jenkins_worker_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["jenkins-worker*"]
  }
}



data "template_file" "user_data" {
  template = file("./scripts/join-cluster.tftpl")
  vars = {
    jenkins_url            = "http://${aws_instance.jenkins_master.public_ip}:8080"
    jenkins_username       = var.jenkins_username
    jenkins_password       = var.jenkins_password
    jenkins_credentials_id = var.jenkins_credentials_id
  }
}



data "aws_vpc" "default_vpc" {
  default = true
}


data "aws_subnets" "us-east-1_default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}


data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "ec2_full_access_policy" {
  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}
