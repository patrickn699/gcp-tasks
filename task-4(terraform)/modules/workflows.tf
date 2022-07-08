resource "google_cloud_run_service" "api-service" {

    name = "weather-api-service"
    region = "us-central1"

    template {
      
      sepc{
        containers {

          name = "weather-api"
          image = "gcr.io/cloud-run/api-service:latest"

          ports {
            container_port = 8080
          }
        }
        
      }

    }

    traffic {
        revision_name = "api-service-v1"
        percent = 100
    }
  
}


resource "google_workflows_workflow" "workflow-1" {

    name = "workflow-1"
    region = "us-central1"
    project = "demo-project"
    source_contents = file("wf.yaml")
    
  
}