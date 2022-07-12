resource "google_sourcerepo_repository" "git-repo" {

    name = "git-repo"
    project = "demo-project"
  
}


resource "google_container_registry" "gcr" {

    name = "gcp_container_registry"
    location = "us-central1"
    
  
}



resource "google_cloud_run_service" "cloud_run" {

    name = "cloud_run"
    location = "us-central1"

    template {
      
      sepc {

        timeout = 120

        containers {

          name = "container-app"
          image = "gcr.io/demo-project/demo-service:latest"

          ports {
            container_port = 80
          }

          volume_mounts {

            name = "app-volume"
            mount_path = "/temp/data"
          }

          resources {

            limits {

            cpu = 2
            memory = 512
          
            }
        }


    }


    }

    traffic {

        revision_name = "cloud_run-v1"
        percent = 100
        }

    traffic {

        revision_name = "cloud_run-v2"
        percent = 25
        }

    }

}



resource "google_cloudbuild_trigger" "cloud_build" {

    name = "gcp-ci/cd-trigger"

    include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"

    git_file_source {
      
       uri = google_sourcerepo_repository.git-repo.url
       repo_type = "CLOUD_SOURCE_REPOSITORY"
       revision = "master"
    }

    trigger_template {
      
      branch_name = "master"
      repo_name = google_sourcerepo_repository.git-repo.name
      
    }

    build {

        source = file("cloudbuild.yaml")
        timeout = 400
    }
  
    approval_config {

      approval_required = true

    }
}



