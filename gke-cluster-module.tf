################################################################################
#
# bootstrap
#   A Terraform project that bootstraps various resources needed to develop
#   and deploy Accentis.
#
# gke-cluster-module.tf
#   Defines the resources related to the CVS repository and corresponding
#   Terraform Cloud workspace.
#
################################################################################

resource "github_repository" "gke_cluster_module" {
    name         = "accentis-gke-cluster-module"
    description  = "A Terraform module that provides a VPC network with a GKE cluster in it"
    visibility   = "public"
    has_issues   = true
    has_projects = false

    archived = false

    allow_merge_commit = false
    allow_squash_merge = true
    allow_rebase_merge = false

    delete_branch_on_merge = true
    license_template       = "mit"

    topics = [
        "terraform",
        "gcp",
        "kubernetes",
    ]
}

resource "github_branch_default" "gke_cluster_module" {
    repository = github_repository.gke_cluster_module.name
    branch     = "main"
}

resource "github_branch_protection" "gke_cluster_module_main" {
    repository_id  = github_repository.gke_cluster_module.node_id
    pattern        = "main"
    enforce_admins = true
    
    required_pull_request_reviews {
      dismiss_stale_reviews = true
      require_code_owner_reviews = true
      required_approving_review_count = 1
    }

    allows_deletions = false
    allows_force_pushes = false
}