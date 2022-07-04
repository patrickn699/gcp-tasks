provider "google" {
    project = "terraform-test-project2"
    #credentials = file("credentials.json")
    
}

module "s2s-n1" {

    source = "./Modules/"
    peer_gateway_1 = [module.s2s-n2.vpn-gateway-2-self-link]
    
}

module "s2s-n2" {

    source = "./Modules/"
    peer_gateway_2 = [module.s2s-n1.vpn-gateway-1-self-link]
}
