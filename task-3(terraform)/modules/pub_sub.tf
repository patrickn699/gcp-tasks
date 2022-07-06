resource "google_pubsub_topic" "my-topic" {

    name = "my-topic"
    project = "demo-project"

    message_storage_policy {

        allowed_persistence_regions = ["asia-east1", "europe-west1", "us-central1"]
      
    }

    message_retention_duration = 57600

}

resource "google_pubsub_topic" "dl-topic" {

    name = "dl-topic"
    project = "demo-project"
    message_retention_duration = 57600
  
}
  
resource "google_pubsub_subscription" "my-subscription" {

    name = "my-subscription"

    topic = google_pubsub_topic.my-topic.name

    ack_deadline_seconds = 20

    message_retention_duration = 60

    enable_message_ordering = true

    expiration_policy {
      
      ttl = "86400s"
    }
    
    dead_letter_policy {
            
            dead_letter_topic = google_pubsub_topic.dl-topic.name
            max_delivery_attempts = 10

    }

    retry_policy {
      
      minimum_backoff = "5s"
      maximum_backoff = "10s"

    }

    
}

resource "google_pubsub_subscription" "dl-subscription" {

    name = "dl-subscription"
    topic = google_pubsub_topic.dl-topic.name
    message_retention_duration = 120
    ack_deadline_seconds = 40


    expiration_policy {
      
      ttl = "86400s"
    }

  
}
