################################################################################
#
# accentis-bootstrap Terraform Project
#
# gcp.tf
#
# This Terraform configuration defines Google Cloud Platform resources.
#
################################################################################

resource "google_project_service" "apis" {
    for_each = toset(var.gcp_projects)

    project                    = each.value
    service                    = "compute.googleapis.com"
    disable_dependent_services = true
}

resource "google_project_service" ""

#
# Global Cloud KMS Keyring
#   This keyring contains all cryptographic keys created in the project.
#
resource "google_kms_key_ring" "project" {
    for_each = toset(var.gcp_projects)

    name     = "${each.value}-keyring"
    location = "global"
}

#
# Disk Encryption Cryptographic Key
#   This cryptographic key is used to provide disk level encryption.
#
resource "google_kms_crypto_key" "disk" {
    for_each = toset(var.gcp_projects)

    name            = "disk-encryption"
    key_ring        = google_kms_key_ring.project.self_link
    purpose         = "ENCRYPT_DECRYPT"
    rotation_period = "7776000s"
}
