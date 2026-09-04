terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

resource "local_file" "project_info" {
  filename = "${path.module}/project-info.txt"

  content = <<-EOT
    Project: Terraform Stage 1
    Environment: Learning
    Managed by: Terraform
  EOT
}

resource "local_file" "environment" {
  filename = "${path.module}/environment.txt"

  content = "This environment is managed by Terraform."
}