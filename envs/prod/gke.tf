# GKE private cluster
resource "google_container_cluster" "mygke" {
  name     = var.gke_cluster_name
  location = var.region
  
  deletion_protection = false
  
  networking_mode = "VPC_NATIVE"
  timeouts {
    create = "60m"
    update = "60m"
    delete = "40m"
  }
  
  ip_allocation_policy {
    cluster_secondary_range_name  = "vpc-pods"
    services_secondary_range_name = "services"
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = 5
    }
    resource_limits {
      resource_type = "memory"
      minimum = 2
      maximum = 6
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.private.name

  initial_node_count = 1
  remove_default_node_pool = true
}

# Node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.mygke.name
  location   = google_container_cluster.mygke.location

  autoscaling {
    min_node_count = 2
    max_node_count = 10
  }
#configure le serveur de métadonnées sur chaque nœud. permet aux pods de s'authentifier en tant que comptes de service Google Cloud
  management {
    auto_repair = true
    auto_upgrade = true
  }

  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 75
    disk_type = "pd-standard"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    
    # workload_metadata_config {
    #   mode = "GKE_METADATA"
    # }
  }
  initial_node_count = 2
  depends_on = [ 
    google_project_service.required_apis["container.googleapis.com"],
    google_project_service.required_apis["storage.googleapis.com"],
   ]
      
}