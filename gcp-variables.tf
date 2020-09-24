################################################################################
#
# accentis-bootstrap Terraform Project
#
# gcp-variables.tf
#
# Terraform Variables used by Google Cloud Platform resources.
#
################################################################################

variable "gcp_project" {
    description = "The GCP project ID"
    type        = string
    default     = "accentis-288921"
}

variable "gcp_apis" {
    description = ""
    type        = set(string)
    default     = [
        "compute.googleapis.com",
        "cloudkms.googleapis.com",
    ]
}
