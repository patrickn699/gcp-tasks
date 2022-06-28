provider "google"{

    project = "terraform-test-project"
    credentials = file("credentials.json")
    region = "us-central1"
}


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
        protocol = "tcp"
        container_port = 80
    }
}

resource "google" "name" {
  
}