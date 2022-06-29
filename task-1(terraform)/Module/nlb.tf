resource "google_compute_network" "vm-vpc" {

    name = "gce-vpc"
    auto_create_subnetworks = false
    
}

resource "google_compute_subnetwork" "vm-subnet" {

    name = "gce-subnet-1"
    network = google_compute_network.vm-vpc.self_link
    region = "us-central1"
    ip_cidr_range = "0.0.0.0/24"
  
}

resource "google_compute_firewall" "vm-firewall" {

    name = "gce-firewall-1"
    network = google_compute_network.vm-vpc.self_link
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]

    allow {
        protocol = "TCP"
        ports = ["80"]
    }
  
}

resource "google_compute_instance_template" "vm-instance-template" {

    name = "gce-instance"
    machine_type = "n1-standard-1"

    network_interface {

        network = google_compute_network.vm-vpc.self_link
        subnetwork = google_compute_subnetwork.vm-subnet.self_link

        access_config {
          
        }
    }

    disk {

        boot = true
        auto_delete = true
        source_image = "debian-9-stretch-v20180806"
        disk_size_gb = 10
        disk_type = "pd-standard"
        

    }
 
}

resource "google_compute_health_check" "vm-health-check" {

    name = "gce-health-check"
    check_interval_sec = 4
    timeout_sec = 5
    unhealthy_threshold = 3
    healthy_threshold = 5

    tcp_health_check {
        port = 80

    }
}


resource "google_compute_instance_group_manager" "vm-instance-group" {

    name = "gce-instance-group"
    zone = "us-central1-a"
    base_instance_name = google_compute_instance_template.vm-instance-template.name

    version {
        instance_template = google_compute_instance_template.vm-instance-template.self_link
    }

    target_size = 4

    auto_healing_policies {

        health_check = google_compute_health_check.vm-health-check.self_link
        initial_delay_sec = 10
    }

    

}

# auto-scaler pendinng
resource "google_compute_autoscaler" "vm-autoscaler" {

    name = "gce-autoscaler"
    zone = "us-central1-a"

    target = google_compute_instance_group_manager.vm-instance-group.self_link

    autoscaling_policy {
        min_replicas = 1
        max_replicas = 6
        
        cpu_utilization {
            target = 0.8
        }
    }
}
  

resource "google_compute_region_backend_service" "vm-backend-service" {

    name = "gce-backend-service"
    region = "us-central1"
    protocol = "TCP"
    
    backend {
        group = google_compute_instance_group_manager.vm-instance-group.self_link
    }

    
}

resource "google_compute_forwarding_rule" "vm-forwarding-rule" {

    name = "gce-forwarding-rule"
    region= "us-central1"
    backend_service = google_compute_region_backend_service.vm-backend-service.self_link
    ip_protocol = "TCP"
    load_balancing_scheme = "EXTERNAL"
    port_range = 80

}

output "nlb-ip" {
    value = google_compute_forwarding_rule.vm-forwarding-rule.ip_address
}