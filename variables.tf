################################################################################
#
# bootstrap
#   A Terraform project that bootstraps various resources needed to develop
#   and deploy Accentis.
#
# variables.tf
#   Defines the variables for this Terraform project.
#
################################################################################

variable "default_compute_engine_service_accounts" {
    description = "A map of default Compute Engine Service Accounts for each managed GCP project"
    type        = map
}

variable "gcp_credentials" {
    description = "A map of base64 encoded GCP credentials for each managed GCP project"
    type        = map
}

variable "gcp_projects" {
    description = "A list of GCP projects managed by this project"
    type        = list(string)
}
