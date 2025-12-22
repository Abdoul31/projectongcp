resource "google_service_account" "terraform" {
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
  project      = var.project_id
}

resource "google_service_account" "github" {
  account_id   = "github-ci"
  display_name = "Service Account for GitHub Actions CI/CD"
}

# resource "google_project_iam_member" "ci_cd_roles" {
#   for_each = toset([
#     "roles/artifactregistry.admin",
#     "roles/container.developer",
#     "roles/storage.admin"
#   ])
#   project = var.project_id
#   role    = each.key
#   member  = "serviceAccount:${google_service_account.ci_cd.email}"
# }