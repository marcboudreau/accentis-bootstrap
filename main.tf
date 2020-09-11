################################################################################
#
# accentis-bootstrap
#
# main.tf
#
# This file defines general Terraform configuration.
#
################################################################################

terraform {
    backend "local" {
        path = "/work/state/terraform.tfstate"
    }

    required_version = "~> 0.13"

    required_providers {
        tfe = {
            version = "~> 0.21"
            source = "hashicorp/tfe"
        }
    }
}
