provider "google" {

    project = "terraform-test-project"
    #credentials = file("credentials.json")
    #region = "us-central1"
  
}

module "glb" {
    source = "./Module/"
}

module "nlb" {
    source = "./Module/"
  
}