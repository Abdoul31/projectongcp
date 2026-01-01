variable "project_id" {
  default = "manssacloudgcp"
}

variable "region" {
  default = "europe-west2"
}
variable "zone" {
  default = "europe-west2-a"
}

variable "network_name" {
  default = "secureshop-vpc"
}

variable "public_subnet_cidr" { 
    default = "10.10.0.0/24" 
    }

variable "private_subnet_cidr" { 
    default = "10.11.0.0/24" 
    }

variable "artifact_repo" { 
    default = "secureshop-repo" 
    }

variable "gke_cluster_name" { 
    default = "secureshop-gke" 
}

variable "cloudsql_instance" { 
    default = "secureshop-sql" 
}

#Pour la prod, transforme node pools en modules et active autoscaling, taints/labels et Workload Identity.