provider "google" {

    project = "demo-project"
    
}

module "sql-n-pubsub" {

    source = "./modules/"
  
}