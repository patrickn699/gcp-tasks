# on-prem ga
resource "google_compute_ha_vpn_gateway" "on-prem-vpn-1" {

    name = "vpn-gateway-1"
    region = "us-central1"
    network = "${var.vpc-1}"
  
}

# gcp ga
resource "google_compute_ha_vpn_gateway" "vpn-2" {

    name = "vpn-gateway-1"
    region = "us-west1"
    network = "${var.vpc-2}"
  
}

# onprem router
resource "google_compute_router" "on-prem-router-1" {

    name = "onprem-router"
    network = "${var.vpc-1}"

    bgp {
      asn = 64513
    }
    

}

# gcp router 
resource "google_compute_router" "router-2" {

    name = "gcp-router"
    network = "${var.vpc-2}"

    bgp {
      asn = 64512
    }
  
}

# onprem vpn tunnel to gcp
resource "google_compute_vpn_tunnel" "tunnel-1" {

    name = "vpn-tunnel-onprem-gcp"
    region = "us-central1"
    vpn_gateway = google_compute_ha_vpn_gateway.on-prem-vpn-1.self_link
    peer_gcp_gateway = google_compute_ha_vpn_gateway.vpn-2.self_link
    shared_secret = "ping-from-gcp-to-onprem"
  
}

# gcp vpn tunnel to onprem
resource "google_compute_vpn_tunnel" "tunnel-2" {

    name = "vpn-tunnel-gcp-onprem"
    region = "us-west1"
    vpn_gateway = google_compute_ha_vpn_gateway.vpn-2.self_link
    peer_gcp_gateway = google_compute_ha_vpn_gateway.on-prem-vpn-1.self_link
    shared_secret = "ping-from-gcp-to-onprem"

}


# router interface to onprem vpn tunnel
resource "google_compute_router_interface" "router-network_interface-1" {

    name = "router-network_interface-1"
    router = google_compute_router.on-prem-router-1.self_link
    region = "us-central1"
    ip_range = "165.254.0.2/24"
    vpn_tunnel = google_compute_vpn_tunnel.tunnel-1.self_link
  
}

# router interface to gcp vpn tunnel
resource "google_compute_router_interface" "router-network_interface-2" {

    name = "router-network_interface-2"
    router = google_compute_router.router-2.self_link
    region = "us-west1"
    ip_range = "169.254.0.1/24"
    vpn_tunnel = google_compute_vpn_tunnel.tunnel-2.self_link
  
}

# router peer to onprem vpn tunnel
resource "google_compute_router_peer" "peer-1" {

    name = "onprem-gcp-peer"
    region = "us-central1"
    router = google_compute_router.on-prem-router-1.self_link
    peer_ip_address = "169.254.0.1"
    peer_asn = 64512
    interface = google_compute_router_interface.router-network_interface-1.name


}

# router peer to gcp vpn tunnel
resource "google_compute_router_peer" "peer-2" {

    name = "gcp-onprem-peer"
    region = "us-west1"
    router = google_compute_router.router-2.self_link
    peer_ip_address = "165.254.0.2"
    peer_asn = 64513
    interface = google_compute_router_interface.router-network_interface-2.name
  
}
