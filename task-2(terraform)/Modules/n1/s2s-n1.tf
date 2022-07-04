# onprem vm

resource "google_compute_network" "on-prem-vpc-1" {

    name = "on-prem-vm-vpc"
    auto_create_subnetworks = false
    routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "on-prem-vm-subnet" {

    name = "on-prem-vm-subnet-1"
    network = google_compute_network.on-prem-vpc-1.self_link
    region = "us-central1"
    ip_cidr_range = "0.0.0.0/24"
  
}

resource "google_compute_firewall" "on-prem-vm-firewall"  {

    name = "vm-firewall-1"
    network = google_compute_network.on-prem-vpc-1.self_link
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]

    allow {
        protocol = "ICMP"
        ports = ["80", "443", "8080","22"]
    }
  
}

resource "google_compute_instance" "on-prem-vm-instance" {

    name = "vm-instance"
    machine_type = "n1-standard-1"
    zone = "us-central1-a"

    network_interface {

        network = google_compute_network.on-prem-vpc-1.self_link
        subnetwork = google_compute_subnetwork.on-prem-vm-subnet.self_link
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
resource "google_compute_ha_vpn_gateway" "vpn-1" {

    name = "vpn-gateway-1"
    region = "us-central1"
    network = google_compute_network.on-prem-vpc-1.self_link
  
}

resource "google_compute_router" "on-prem-router-1" {

    name = "onprem-router"
    network = google_compute_network.on-prem-vpc-1.self_link

    bgp {
      asn = 64513
    }
    

}

resource "google_compute_vpn_tunnel" "tunnel-1" {

    name = "vpn-tunnel-onprem-gcp"
    region = "us-central1"
    vpn_gateway = google_compute_ha_vpn_gateway.vpn-1.self_link
    peer_gcp_gateway = "${var.peer_gateway_1}"
    shared_secret = "ping-from-gcp-to-onprem"
  
}

resource "google_compute_router_interface" "router-network_interface-1" {

    name = "router-network_interface-1"
    router = google_compute_router.on-prem-router-1.self_link
    region = "us-central1"
    ip_range = "165.254.0.2/24"
    vpn_tunnel = google_compute_vpn_tunnel.tunnel-1.self_link
  
}

resource "google_compute_router_peer" "peer-1" {

    name = "onprem-gcp-peer"
    region = "us-central1"
    router = google_compute_router.on-prem-router-1.self_link
    peer_ip_address = "169.254.0.1"
    peer_asn = 64512
    interface = google_compute_router_interface.router-network_interface-1.name


}
*/
output "vpc-name" {
    value = google_compute_network.on-prem-vpc-1.self_link
}


