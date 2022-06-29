resource "google_cloud_run_service" "container_app" {

    name = "docker-app"
    region = "us-central1"

    template {
      spec {
        containers {
          name = "sample-app"
          image = "gcr.io/terraform-test-project/docker-app:0.0.1"
        }
      }
    }

    traffic {
      revision_name = "first"
      percent = 100
    }

    ports {
        protocol = "TCP"
        container_port = 80
    }
}

resource "google_compute_network_endpoint_group" "neg-cloud-run"{

    name = "neg-lb-cloud-run"
    network = "default"
    subnetwork = "subnet-1"
    zone = "us-central1-a"
    network_endpoint_type = "SERVERLESS"

    cloud_run {
        service = google_cloud_run_service.container_app.name

    }

} 


resource "google_compute_backend_service" "neg-backend-cloud-run" {

    name = "backend-cloud-run"

    backend {
       group = google_compute_network_endpoint_group.neg-cloud-run.self_link
    }

    load_balancing_scheme = "EXTERNAL"
    port_name = 80
    protocol = "HTTP"
  
}

resource "google_compute_url_map" "neg-url-map" {

    name = "url-map-cloud-run"
    default_service = google_compute_backend_service.neg-backend-cloud-run.self_link
  
}

resource "google_compute_target_http_proxy" "neg-target-http-proxy" {

    name = "target-http-proxy-cloud-run"
    url_map = google_compute_url_map.neg-url-map.self_link
  
}

resource "google_compute_global_forwarding_rule" "neg-forwarding-rule" {

    name = "forwarding-rule-cloud-run"
    target = google_compute_target_http_proxy.neg-target-http-proxy.self_link
    ip_protocol = "TCP"
    load_balancing_scheme = "EXTERNAL"
    port_range = 80
    
  
}

output "ext_lb_ip_address" {
    value = google_compute_global_forwarding_rule.neg-forwarding-rule.ip_address
}
  


  