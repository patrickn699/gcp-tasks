resource "google_cloud_run_service" "container_app" {

    name = "docker-app"
    location = "us-central1"


    template {
      spec {
        containers {
          image = "gcr.io/terraform-test-project/docker-app:0.0.1"
          ports {
            container_port = 8080
            protocol = "TCP"
          }
        }
      }
    }

    traffic {
      revision_name = "first"
      percent = 100
    }

    
}

resource "google_compute_region_network_endpoint_group" "neg-cloud-run"{

    description = "network endpoint group is a collection of network endpoints"

    name = "neg-lb-cloud-run"
    region = "us-central1"
    network_endpoint_type = "SERVERLESS"

   cloud_run {

        service = google_cloud_run_service.container_app.name
       
   }

} 


resource "google_compute_backend_service" "neg-backend-cloud-run" {

    description = "backend service for network endpoint group"

    name = "backend-cloud-run"

    backend {
       group = google_compute_region_network_endpoint_group.neg-cloud-run.self_link
    }

    load_balancing_scheme = "EXTERNAL"
    port_name = 80
    protocol = "HTTP"
  
}

resource "google_compute_url_map" "neg-url-map" {

    description = "url map for backend service"

    name = "url-map-cloud-run"
    default_service = google_compute_backend_service.neg-backend-cloud-run.self_link
  
}

resource "google_compute_target_http_proxy" "neg-target-http-proxy" {

    description = "target http proxy for url map"

    name = "target-http-proxy-cloud-run"
    url_map = google_compute_url_map.neg-url-map.self_link
  
}

resource "google_compute_global_forwarding_rule" "neg-forwarding-rule" {

    description = "forwarding rule for target http proxy"

    name = "forwarding-rule-cloud-run"
    target = google_compute_target_http_proxy.neg-target-http-proxy.self_link
    ip_protocol = "TCP"
    load_balancing_scheme = "EXTERNAL"
    port_range = 80
    
  
}

output "ext_lb_ip_address" {
    value = google_compute_global_forwarding_rule.neg-forwarding-rule.ip_address
}
  


  