variable "AWS_ACCESS_KEY" {

}

variable "AWS_SECRET_KEY" {

}


data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_subnet" "internal" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "eu-central-1a"
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
}

module "k3s_cluster" {
  source                    = "./k3s_cluster/"

  aws_region                = var.aws_region
  environment               = "staging"
  public_ip_cidr            = "172.31.16.0/20"
  vpc_id                    = var.vpc_id.id
  vpc_subnets               = var.
  vpc_subnet_cidr           = var.vpc_id
  cluster_name              = "k3s-cluster"
  create_extlb              = true # or flase
  expose_kubeapi            = true # or flase
  efs_persistent_storage    = true # or flase
  certmanager_email_address = true # or flase
  
}

output "elb_dns_name" {
  value = module.k3s_cluster.elb_dns_name
}

output "k3s_server_public_ips" {
  value = module.k3s_cluster.k3s_server_public_ips
}

output "k3s_workers_public_ips" {
  value = module.k3s_cluster.k3s_workers_public_ips
}