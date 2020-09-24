################################################################################
#
# accentis-bootstrap
#
# tc.tf
#
# This Terraform configuration defines Terraform Cloud resources.
#
################################################################################

resource "tfe_organization" "accentis" {
    name = "accentis"
    email = "marc.a.boudreau+accentis@gmail.com"
}

resource "tfe_workspace" "accentis_bootstrap" {
    name             = "accentis-bootstrap"
    tfe_organization = tfe_organization.accentis.name
}