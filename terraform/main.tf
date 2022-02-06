data "aws_availability_zones" "available" {}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "aws_vpc" "main" {
   cidr_block = "${var.servian_vpc_cidr}"
   instance_tenancy = "default"

   tags = {
        Name = "${var.vpc_name}-${var.environment}" 
        Environment = "${var.environment}"
    }
 }

resource "aws_subnet" "public" {
  count = length(var.servian_subnets_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.servian_subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-${var.environment}-subnet-${count.index+1}"
    Environment = "${var.environment}"
  }
}

# resource "aws_security_group" "all_worker_mgmt" {
#   name_prefix = "${var.project_name}-${var.environment}_worker_management"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"

#     cidr_blocks = [
#       "${var.servian_vpc_cidr}",
#     ]
#   }
# }

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = "${var.project_name}-${var.environment}_eks_cluster"
  cluster_version = "1.20"
  subnets         = aws_subnet.public.*.id
  vpc_id          = aws_vpc.main.id
  manage_aws_auth = false

  worker_groups = [
    {
      instance_type = "t2.micro"
      asg_max_size  = 2
    }
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}_eks_cluster"
    Environment = "${var.environment}"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# module "eks" {
#   source          = "terraform-aws-modules/eks/aws"
#   version         = "17.24.0"
#   cluster_name    = "${var.project_name}-${var.environment}_eks_cluster"
#   cluster_version = "1.20"
#   subnets         = aws_subnet.public.*.id

#   vpc_id = aws_vpc.main.id

#   cluster_endpoint_private_access = "true"
#   cluster_endpoint_public_access  = "true"

#   workers_group_defaults = {
#     root_volume_type = "gp2"
#   }

#   worker_groups = [
#     {
#       name                          = "${var.project_name}-${var.environment}-worker-group-1"
#       instance_type                 = "t2.micro"
#       additional_userdata           = "echo test1"
#       additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
#       asg_desired_capacity          = 2
#     },
#      {
#       name                          = "${var.project_name}-${var.environment}-worker-group-2"
#       instance_type                 = "t2.micro"
#       additional_userdata           = "echo test2"
#       additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
#       asg_desired_capacity          = 1
#     },
#   ]
# }

resource "aws_db_subnet_group" "postgres_db_subnet_group" {
  name       = "${var.project_name}-${var.environment}-postgres-subnet-group"
  subnet_ids = aws_subnet.public.*.id

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres-subnet-group"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "sg-rds" {
  name   = "${var.project_name}-${var.environment}-sg-rds"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-sg-rds"
    Environment = "${var.environment}"
  }
}

resource "aws_db_parameter_group" "postgres_db_para-group" {
  name   = "${var.project_name}-${var.environment}-para-group"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "${var.project_name}-${var.environment}-postgres-rds"
  instance_class         = var.postgresql_instance_type
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "postgres"
  password               = var.postgre_db_password
  db_subnet_group_name   = aws_db_subnet_group.postgres_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.sg-rds.id]
  parameter_group_name   = aws_db_parameter_group.postgres_db_para-group.name
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "${var.project_name}-${var.environment}-postgres-rds"
    Environment = "${var.environment}"
  }
}

