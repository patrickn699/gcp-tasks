provider "google" {
    project = "terraform-test-project2"
    #credentials = file("credentials.json")
    
}

module "onprem-vm" {
    source = "./Modules/n1/"

}

module "gcp-vm" {
    source = "./Modules/n2/"
}

module "ga" {
    source = "./Modules/vpn-ga/"
    vpc-1 = module.onprem-vm.vpc-name
    vpc-2 = module.gcp-vm.vpc-name
  
}
