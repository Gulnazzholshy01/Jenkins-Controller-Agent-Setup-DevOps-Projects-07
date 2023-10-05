packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}


variable "ami_name" {
  type    = string
  default = "jenkins-worker"
}


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  tags = {
    Name          = "jenkins-worker"
    OS_Version    = "Ubuntu22.04"
    Base_AMI_ID   = "{{ .SourceAMI }}"
  }
}


data "amazon-ami" "ubuntu_ami" {
  region      = "us-east-1"
  most_recent = true
  owners      = ["amazon"]
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
}

source "amazon-ebs" "basic" {
  shared_credentials_file = "/Users/gulnazzholshy/.aws/credentials"
  profile                 = "default"
  region                  = "us-east-1"
  ssh_username            = "ubuntu"
  instance_type           = "t2.micro"
  ami_name                = "${var.ami_name}-${local.timestamp}"
  ami_description         = "AMI for Jenkins Worker node"
  source_ami              = data.amazon-ami.ubuntu_ami.id
  tags                    = "${local.tags}"
}


build {
  sources = [
    "source.amazon-ebs.basic"
  ]


  provisioner "shell" {
    script          = "./setup.sh"
    execute_command = "sudo -E -S sh '{{ .Path }}'"
  }
}

