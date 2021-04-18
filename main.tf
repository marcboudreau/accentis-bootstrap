################################################################################
#
# bootstrap
#   A Terraform project that bootstraps various resources needed to develop
#   and deploy Accentis.
#
# main.tf
#   Defines the Terraform settings and resources.
#
################################################################################

terraform {
  required_version = "~> 0.15.0"

  required_providers {
    tfe = {
        version = "~> 0.24.0"
    }
    github = {
        source  = "integrations/github"
        version = "~> 4.9.2"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "accentis"

    workspaces {
        name = "bootstrap"
    }
  }
}

# resource "tfe_oauth_client" "" {
#     organization     = "marcboudreau"
#     api_url          = "https://api.github.com"
#     http_url         = "https://github.com"
#     oauth_token      = "value"
#     service_provider = "github"
# }

