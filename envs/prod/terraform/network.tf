# VPC
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

# Subnets: public for LB, private for nodes
resource "google_compute_subnetwork" "public" {
  name          = "${var.network_name}-public"
  ip_cidr_range = var.public_subnet_cidr
  region          = var.region
  network       = google_compute_network.vpc.id
  # enable private Google access if needed
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private" {
  name          = "${var.network_name}-private"
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
#Secondary ranges keep pod and service IPs separate from node IPs
 secondary_ip_range {
  range_name = "vpc-pods"
  ip_cidr_range = "10.4.0.0/20"
  
   }

  secondary_ip_range {
    range_name = "services"
    ip_cidr_range = "10.6.0.0/20"
  }

  private_ip_google_access = true
 }

# Reserve pod/service ranges (for GKE)
resource "google_compute_global_address" "add-pods" {
  name          = "${var.network_name}-add-pods"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_compute_global_address" "add-services" {
  name          = "${var.network_name}-add-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = google_compute_network.vpc.id
}

# Service Networking connection (Private Service Access) - required for Cloud SQL private ip
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.add-pods.name]
  depends_on              = [google_compute_global_address.add-pods, google_compute_global_address.add-services]
}
