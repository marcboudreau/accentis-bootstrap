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

resource "tfe_workspace" "bootstrap" {
  name                  = "bootstrap"
  organization          = "accentis"
  allow_destroy_plan    = false
  queue_all_runs        = false
  execution_mode        = "remote"

  vcs_repo {
      identifier     = "marcboudreau/accentis-bootstrap"
      branch         = "main"
      oauth_token_id = ""
  }
}

