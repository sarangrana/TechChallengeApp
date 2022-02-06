output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = aws_subnet.public.*.id
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_name" {
  value = "${var.project_name}-${var.environment}_eks_cluster"
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       =  module.eks.cluster_security_group_id
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.postgres.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.postgres.username
}

output "rds_password" {
  description = "RDS instance root password"
  value       = aws_db_instance.postgres.password
  sensitive   = true
}

output "rds_dbname" {
  description = "RDS instance DB name"
  value       = aws_db_instance.postgres.name
}