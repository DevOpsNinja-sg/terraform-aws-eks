module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version  = "~>20.31"

    cluster_name = "${local.name}-cluster"
    cluster_version = "1.31"
    cluster_endpoint_public_access = true

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    control_plane_subnet_ids = module.vpc.intra_subnets

    eks_managed_node_group_defaults = {
        instance_type = "t2.micro"
        attach_cluter_primary_security_group = true

    }
    cluster_addons = {
        vpc-cni = {
            most-recent = true
        }
        kube-proxy = {
            most-recent = true
        }
        coredns = {
            most-recent = true
        }
    }

    eks_managed_node_groups = {
        eks_nodes = {
            instance_type = "t2.micro"
            desired_capacity = 2
            min_size = 1
            max_size = 4

            capacity_type = "SPOT"
        }

    }

    tags = {
        Environment = local.env
        Terraform   = "true"
    }
}