provider "google" {

    project = "terraform-test-project"
    #credentials = file("credentials.json")
    
  
}

module "glb" {
    source = "./Module/"
}

module "nlb" {
    source = "./Module/"
  
}