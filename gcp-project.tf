################################################################################
#
# bootstrap
#   A Terraform project that bootstraps various resources needed to develop
#   and deploy Accentis.
#
# gcp-project.tf
#   Defines the resources related to the CVS repository and corresponding
#   Terraform Cloud workspace.
#
################################################################################

locals {
    #
    # project_ids is a list of GCP Project ID to manage.  The list items are
    # are actually just the variable part that comes after 'accentis-'.
    #
    project_ids = [
        "288921"
    ]
}

resource "tfe_workspace" "gcp_project" {
    for_each = toset(local.project_ids)

    name               = "accentis-gcp-project-${each.value}"
    organization       = "accentis"
    allow_destroy_plan = false
    queue_all_runs     = false
    execution_mode     = "remote"

    vcs_repo {
        identifier   = "marcboudreau/accentis-gcp-project"
        description  = "A Terraform project containing the configuration for project-wide resources in GCP Projects used for Accentis"
        visibility   = "private"
        has_issues   = true
        has_projects = false

        archived     = false

        allow_merge_commit = false
        allow_squash_merge = true
        allow_rebase_merge = false

        delete_branch_on_merge = true
        license_template       = "mit"

        topics = [
            "terraform",
            "gcp",
            "iam",
            "kms",
        ]
    }
}