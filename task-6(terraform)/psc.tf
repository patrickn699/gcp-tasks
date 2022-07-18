resource "google_compute_network" "vpc" {

    name = "vpc"
    auto_create_subnetworks = false
    
  
}

resource "google_compute_subnetwork" "subnet" {

    name = "subnet"
    region = "us-central1"
    network = google_compute_network.vpc.self_link
    ip_cidr_range = "10.0.0.0/24"

  
}

resource "google_compute_instance" "vm" {

    name =  "gce-vm"
    machine_type = "n1-standard-1"
    zone = "us-central1-a"

    network_interface {

        network = google_compute_network.vpc.self_link
        subnetwork = google_compute_subnetwork.subnet.self_link
      
    }

    boot_disk {
          
            initialize_params {
    
                image = "debian-9-stretch-v20190319"
                disk_size_gb = 10
                disk_type = "pd-standard"
            }
    }

    deletion_protection = "true"
}


resource "google_storage_bucket" "storage_bucket" {

    name = "storage-bucket"
    location = "us-central1"
    storage_class = "STANDARD"

  
}

resource "google_compute_global_address" "private_internal_ip" {

  name          = "private_internal_ip"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.self_link


}

resource "google_service_networking_connection" "srvice-connect" {

    network                 = google_compute_network.vpc.self_link
    service                 = "sotrage.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.private_internal_ip.address]

}


resource "google_dns_managed_zone" "private-dns" {

    name = "private-dns"
    visibility = "private"
    dns_name = "p.googleapis.com"

    private_visibility_config {

        networks {

            network_url = google_compute_network.vpc.id
          
        }
      
      

    }

}

resource "google_dns_record_set" "dns_record" {

    name = "storage.p.googleapis.com"
    managed_zone = google_dns_managed_zone.private-dns.name
    type = "A"
    ttl = "120"
    rrdatas = [google_compute_global_address.private_internal_ip.address]
    

}
