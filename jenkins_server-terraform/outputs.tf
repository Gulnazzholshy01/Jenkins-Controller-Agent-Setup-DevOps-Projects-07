output "instance_public_ip" {
  value = aws_instance.jenkins_master.public_ip

}

output "jenkins_server" {
  value = "http://${aws_instance.jenkins_master.public_ip}:8080"
}