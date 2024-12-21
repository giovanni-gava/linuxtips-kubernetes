terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}


# Provedor AWS
provider "aws" {
  region = "us-east-1" # Altere para a sua região desejada
}

# Criar uma VPC para o cluster EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"


  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway    = false
  enable_dns_support    = true
  enable_dns_hostnames  = true
}


# Criar o cluster EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.0" # Versão compatível com o provedor

  cluster_name    = "eks-cluster-study"
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Logs habilitados no cluster
  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  # Grupos de nós gerenciados
  eks_managed_node_groups = {
    study-nodes = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      instance_types = ["t3.small"]
      ami_type       = "AL2_x86_64"
    }
  }

  # Tags padrão para recursos
  tags = {
    Environment = "Study"
    Project     = "EKS Cluster"
  }
}
