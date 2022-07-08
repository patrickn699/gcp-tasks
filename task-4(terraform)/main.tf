provider "google" {

    project = "demo-project"
    
  
}

module "function-n-worlflows" {
    
    source = "./modules/"
}