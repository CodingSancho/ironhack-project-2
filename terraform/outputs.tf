# ============================================================
# Outputs — useful after terraform apply
# ============================================================

output "instance_a_public_ip" {
  description = "Public IP of Instance A (Vote + Result + Bastion)"
  value       = aws_eip.instance_a.public_ip
}

output "instance_b_private_ip" {
  description = "Private IP of Instance B (Redis + Worker)"
  value       = aws_instance.instance_b.private_ip
}

output "instance_c_private_ip" {
  description = "Private IP of Instance C (PostgreSQL)"
  value       = aws_instance.instance_c.private_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "ssh_bastion_command" {
  description = "SSH command to reach Instance A"
  value       = "ssh -i ~/.ssh/viktor-useast1-dvft.pem ec2-user@${aws_eip.instance_a.public_ip}"
}

output "ssh_to_b_via_bastion" {
  description = "SSH to Instance B via bastion (run from Instance A)"
  value       = "ssh -i ~/.ssh/viktor-useast1-dvft.pem ec2-user@${aws_instance.instance_b.private_ip}"
}

output "ssh_to_c_via_bastion" {
  description = "SSH to Instance C via bastion (run from Instance A)"
  value       = "ssh -i ~/.ssh/viktor-useast1-dvft.pem ec2-user@${aws_instance.instance_c.private_ip}"
}
