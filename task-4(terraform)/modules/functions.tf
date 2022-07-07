resource "google_storage_bucket" "img_bucket" {

    name = "upload-bucket"
    location = "europe-west1"
    project = "demo-project"
    storage_class = "standard"
  
}

resource "google_storage_bucket" "resize_bucket" {

    name = "download-bucket"
    location = "europe-east1"
    project = "demo-project"
    storage_class = "standard"
  
}

resource "google_storage_bucket" "src_bucket" {

    name = "download-bucket"
    location = "europe-east1"
    project = "demo-project"
    storage_class = "standard"
  
}

resource "google_cloudfunctions_function" "img-resize" {

    name = "img-resize"
    runtime = "python37"

    available_memory_mb = 256
    timeout = 120

    source_archive_bucket = google_storage_bucket.src_bucket.name
    source_archive_object = "wf.zip"
    entry_point = "main"

    event_trigger {

        event_type = "google.storage.object.finalize"
        resource = google_storage_bucket.img_bucket.name

        failure_policy {
          
          retry = true

        }

    }

    max_instances = 4
    min_instances = 2


  
}

