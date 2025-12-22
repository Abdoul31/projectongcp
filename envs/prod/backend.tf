 #ce dossier doit exixter avant terraform init
terraform {
  backend "gcs" {
    bucket = "terraform-state-back"
  }
  
}

# Enable required APIs before creating resources
resource "google_project_service" "required_apis" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
    "artifactregistry.googleapis.com",
    "servicenetworking.googleapis.com",
  ])
  
  service            = each.key
  disable_on_destroy = false
}