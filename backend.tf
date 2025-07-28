terraform {
  backend "s3" {
    bucket         = "iac-statefiles-terraform"  # Replace with actual
    key            = "eks-automation/terraform.tfstate"
    region         = "ap-south-1" 
    encrypt        = true
    # dynamodb_table = "terraform-locks"  # Replace with actual
  }
}