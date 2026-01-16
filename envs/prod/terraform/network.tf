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

# Reserve pod/service ranges pour gke
resource "google_compute_global_address" "add-pods" {
  name          = "${var.network_name}-add-pods"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}
# peering pour SQL
resource "google_compute_global_address" "add-services" {
  name          = "${var.network_name}-add-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 20
  network       = google_compute_network.vpc.id
  address       = "10.20.0.0"
}

# Service réseau pour la connection privée du cloud sql posgre
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.add-pods.name]
  #depends_on              = [google_compute_global_address.add-pods, google_compute_global_address.add-services]
  deletion_policy = "ABANDON"
}


# Configuration Cloud NAT pour le cluster gke
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
  
  bgp {
    asn               = 64514
    advertise_mode    = "CUSTOM"  # Amélioration : Contrôle des routes annoncées
    advertised_groups = ["ALL_SUBNETS"]
    
    # Optionnel : Annoncer des plages personnalisées
    # advertised_ip_ranges {
    #   range = "10.0.0.0/8"
    # }
  }
}

# IPs NAT statiques (haute disponibilité)
resource "google_compute_address" "nat_ip" {
  count  = 2
  name   = "${var.network_name}-nat-ip-${count.index}"
  region = var.region
  
}
# Configuration cloud router pour le routage dynamique BGP
resource "google_compute_router_nat" "nat" {
  name   = "${var.network_name}-nat"
  router = google_compute_router.router.name
  region = var.region
  
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.nat_ip[*].self_link
  
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  
  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}