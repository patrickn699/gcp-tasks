provider "google" {
    
    project = "terraform-test-project"
    credentials = file("credentials.json")
    region = "us-central1"
  
}

module "global-laod-balancer" {
    source = "./main-glb.tf"
}

module "network-load-balancer" {
    source = "./nlb.tf"
  
}