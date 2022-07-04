resource "google_compute_network" "vpc-2" {

    name = "vm-vpc-2"
    auto_create_subnetworks = false
    routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "vm-subnet" {

    name = "vm-subnet-2"
    network = google_compute_network.vpc-2.self_link
    region = "us-west1"
    ip_cidr_range = "0.0.0.0/24"
  
}

resource "google_compute_firewall" "vm-firewall"  {

    name = "vm-firewall-2"
    network = google_compute_network.vpc-2.self_link
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]

    allow {
        protocol = "ICMP"
        ports = ["80", "443", "8080","22"]
    }
  
}

resource "google_compute_instance" "vm-instance" {

    name = "vm-instance-2"
    machine_type = "n1-standard-1"
    zone = "us-west1-a"

    network_interface {

        network = google_compute_network.vpc-2.self_link
        subnetwork = google_compute_subnetwork.vm-subnet.self_link
        access_config {
            
        }
    }

    boot_disk {
          
            initialize_params {
                image = "debian-9-stretch-v20180806"
                size = 10
                type = "pd-standard"
            }
    }
  
}


/*
resource "google_compute_ha_vpn_gateway" "vpn-2" {

    name = "vpn-gateway-1"
    region = "us-west1"
    network = google_compute_network.vpc-2.self_link
  
}

resource "google_compute_router" "router-2" {

    name = "gcp-router"
    network = google_compute_network.vpc-2.self_link

    bgp {
      asn = 64512
    }
  
}

resource "google_compute_vpn_tunnel" "tunnel-2" {

    name = "vpn-tunnel-gcp-onprem"
    region = "us-west1"
    vpn_gateway = google_compute_ha_vpn_gateway.vpn-2.self_link
    peer_gcp_gateway = "${var.peer_gateway_2}"
    shared_secret = "ping-from-gcp-to-onprem"

}

resource "google_compute_router_interface" "router-network_interface-2" {

    name = "router-network_interface-2"
    router = google_compute_router.router-2.self_link
    region = "us-west1"
    ip_range = "169.254.0.1/24"
    vpn_tunnel = google_compute_vpn_tunnel.tunnel-2.self_link
  
}

resource "google_compute_router_peer" "peer-2" {

    name = "gcp-onprem-peer"
    region = "us-west1"
    router = google_compute_router.router-2.self_link
    peer_ip_address = "165.254.0.2"
    peer_asn = 64513
    interface = google_compute_router_interface.router-network_interface-2.name
  
}

*/

output "vpc-name" {
    value = google_compute_network.vpc-2.self_link
}

