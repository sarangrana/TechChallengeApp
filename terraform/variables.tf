variable "project_name" {
  description = "To differentiate the resources based on project name"
  default     = "servian-tech-challenge"
}

variable "environment" {
  description = "To decide project environment"
  default     = "dev"
}

variable "vpc_name" {
  description = "New VPC name"
  default     = "vpc-servian"
}

variable "servian_vpc_cidr" {
  description = "Servian VPC cidr"
  default     = "10.0.0.0/16"
}

variable "servian_subnets_cidr" {
	type = list
	default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
	type = list
	default = ["us-east-2a", "us-east-2b"]
}

variable "postgre_db_version" {
  description = "PostgreSQL Database version to be used"
  default     = "10.07"
}

variable "postgre_db_password" {
  description = "PostgreSQL Database password"
  sensitive   = true
}

variable "postgresql_instance_type" {
  description = "PostgreSQL Database instance type"
  default     = "db.t3.medium"
}
