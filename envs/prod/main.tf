# Artifact Registry/Container Repo
resource "google_artifact_registry_repository" "container_repo" {
  provider = google
  location = var.region
  repository_id = var.artifact_repo
  format = "DOCKER"
}

# Cloud SQL (Postgres) - private IP only
resource "google_sql_database_instance" "postgres" {
  name             = var.cloudsql_instance
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro" # adapt for prod
    ip_configuration {
      ipv4_enabled = false
      private_network = google_compute_network.vpc.id
    }
  }
  deletion_protection = false
}
