variable "vpc_cidr" {
  type = string
  description = "CIDR block of the existing VPC"
  default = "10.0.0.0/16"  # Replace with your VPC's actual CIDR
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment (dev, test, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Must be dev, test, or prod."
  }
}

variable "existing_vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS nodes"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (for load balancers if needed)"
  type        = list(string)
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "node_instance_types" {
  description = "Node instance types"
  type        = list(string)
}

variable "node_desired_size" {
  type = number
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "enable_public_access" {
  description = "Enable public EKS endpoint"
  type        = bool
  default     = false  # Private for prod-grade
}