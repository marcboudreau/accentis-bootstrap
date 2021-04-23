################################################################################
#
# bootstrap
#   A Terraform project that bootstraps various resources needed to develop
#   and deploy Accentis.
#
# bootstrap.tf
#   Defines the resources related to the CVS repository and corresponding
#   Terraform Cloud workspace.
#
################################################################################

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

resource "github_repository" "bootstrap" {
    name         = "accentis-bootstrap"
    description  = "A Terraform project containing the bootstrap configuration for GitHub and Terraform Cloud resources"
    visibility   = "public"
    has_issues   = true
    has_projects = false

    archived     = false

    allow_merge_commit = false
    allow_squash_merge = true
    allow_rebase_merge = false

    delete_branch_on_merge = true
    license_template       = "mit"

    topics = ["terraform"]
}