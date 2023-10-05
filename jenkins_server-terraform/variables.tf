variable "key_name" {
  description = "SSH key"
  type        = string
}

variable "master_instance_type" {
  description = "Master Instance type"
  type        = string
}

variable "worker_instance_type" {
  description = "Worker Instance type"
  type        = string
}


variable "master_instance_name" {
  description = "Master instance name"
  type        = string
}

variable "worker_instance_name" {
  description = "Worker instance name"
  type        = string
}


variable "port22_ips" {
  description = "Allowed IPs on port 22"
  type        = list(string)
}


variable "master_root_volume_size" {
}

variable "worker_root_volume_size" {
}


variable "https_cidr" {
  type        = list(string)
  description = "List of HTTPS cidrs"
}

variable "jenkins_username" {
  type        = string
  description = "Jenkins admin user"
}

variable "jenkins_password" {
  type        = string
  description = "Jenkins admin password"
}


variable "jenkins_credentials_id" {
  type        = string
  description = "Jenkins workers SSH based credentials id"
}

