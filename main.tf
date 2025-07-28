# Custom Security Group for EKS Cluster Control Plane
resource "aws_security_group" "eks_cluster" {
  name        = "${var.environment}-eks-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.existing_vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-eks-cluster-sg"
    Environment = var.environment
  }
}

#Security Group for EKS Worker Nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.environment}-eks-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.existing_vpc_id

  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]  # Allow from cluster SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-eks-nodes-sg"
    Environment = var.environment
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                   = "${var.environment}-${var.cluster_name}"
  kubernetes_version      = var.cluster_version
  subnet_ids             = var.private_subnet_ids

  endpoint_public_access = var.enable_public_access
  endpoint_private_access = true

  # Custom Cluster SG
  security_group_id = aws_security_group.eks_cluster.id

  # Custom Node SG
  node_security_group_id = aws_security_group.eks_nodes.id

  # Disable module's default SG creation
  create_security_group = false
  create_node_security_group    = false

  addons = {
    coredns    = { most_recent = true }
    kube-proxy = { most_recent = true }
    vpc-cni    = { most_recent = true }
  }

  eks_managed_node_groups = {
    default = {
      name            = "${var.environment}-node-group"
      instance_types  = var.node_instance_types
      desired_size    = var.node_desired_size
      min_size        = var.node_min_size
      max_size        = var.node_max_size
      ami_type        = "AL2023_x86_64_STANDARD"
      capacity_type   = var.environment == "prod" ? "ON_DEMAND" : "SPOT"
      disk_size       = 50
      labels          = { environment = var.environment }
      update_config   = { max_unavailable = 1 }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}