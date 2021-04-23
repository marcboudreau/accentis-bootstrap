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

resource "tfe_workspace" "gcp_project" {
    for_each = toset(var.gcp_projects)

    name                  = "accentis-gcp-project-${element(split("-", each.value), 1)}"
    organization          = "accentis"
    allow_destroy_plan    = false
    queue_all_runs        = false
    execution_mode        = "remote"
    speculative_enabled   = false
    file_triggers_enabled = false
}

resource "tfe_variable" "gcp_project_project_id" {
    for_each = toset(var.gcp_projects)

    key          = "project_id"
    value        = each.value
    category     = "terraform"
    workspace_id = tfe_workspace.gcp_project[each.value].id
}

resource "tfe_variable" "gcp_project_default_sa" {
    for_each = toset(var.gcp_projects)

    key          = "default_compute_engine_service_account"
    value        = var.default_compute_engine_service_accounts[each.value]
    category     = "terraform"
    workspace_id = tfe_workspace.gcp_project[each.value].id
}

resource "tfe_variable" "gcp_project_credentials" {
    for_each = toset(var.gcp_projects)

    key          = "GOOGLE_CREDENTIALS"
    value        = replace(base64decode(var.gcp_credentials[each.value]),"\n","")
    category     = "env"
    sensitive    = true
    description  = "Service Account Key used to make GCP API calls"
    workspace_id = tfe_workspace.gcp_project[each.value].id
}

resource "github_repository" "gcp_project" {
    name          = "accentis-gcp-project"
    description   = "A Terraform project containing the configuration for project-wide resources in GCP Projects used for Accentis"
    visibility    = "public"
    has_issues    = true
    has_projects  = false
    has_downloads = false
    has_wiki      = false

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
