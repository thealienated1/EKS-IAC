terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"  # Replace with actual
    key            = "eks-automation/terraform.tfstate"
    region         = "ap-south-1" 
    dynamodb_table = "terraform-locks"  # Replace with actual
    encrypt        = true
  }
}