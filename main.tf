module "compartment" {
  count        = var.compartment_creation_enabled ? 1 : 0
  source       = "./compartment"
  tenancy_ocid = var.tenancy_ocid
  compartment = {
    name        = "terraformed"
    description = "Compartment for Terraform'ed resources"
  }
}

module "network" {
  source                   = "./network"
  compartment_id           = var.compartment_creation_enabled ? module.compartment[0].id : var.compartment_id
  region                   = var.region
  vcn_dns_label            = "vcn"
  public_subnet_dns_label  = "public"
  provision_private_subnet = false
}

module "compute" {
  source              = "./compute"
  compartment_id      = var.compartment_creation_enabled ? module.compartment[0].id : var.compartment_id
  ssh_key_pub_path    = var.ssh_key_pub_path
  load_balancer_id    = module.network.load_balancer_id
  availability_domain = 0

  leader = {
    shape            = "VM.Standard.A1.Flex" # ARM-based processor
    image            = "Canonical-Ubuntu-20.04-aarch64-2022.10.31-0"
    ocpus            = 1
    memory_in_gbs    = 3
    hostname         = "leader"
    subnet_id        = module.network.public_subnet_id
    assign_public_ip = true
  }
  workers = {
    count            = 3
    shape            = "VM.Standard.A1.Flex" # ARM-based processor 
    image            = "Canonical-Ubuntu-20.04-aarch64-2022.10.31-0"
    ocpus            = 1
    memory_in_gbs    = 7
    base_hostname    = "worker"
    subnet_id        = module.network.public_subnet_id
    assign_public_ip = true
  }
}

module "k8s" {
  source                              = "./k8s"
  ssh_key_path                        = var.ssh_key_path
  cluster_public_ip                   = module.network.reserved_public_ip.ip_address
  cluster_public_dns_name             = var.cluster_public_dns_name
  load_balancer_id                    = module.network.load_balancer_id
  leader                              = module.compute.leader
  workers                             = module.compute.workers
  windows_overwrite_local_kube_config = var.windows_overwrite_local_kube_config
}

module "k8s_scaffold" {
  source                         = "./k8s-scaffold"
  depends_on                     = [module.k8s]
  ssh_key_path                   = var.ssh_key_path
  cluster_public_ip              = module.network.reserved_public_ip.ip_address
  cluster_public_dns_name        = var.cluster_public_dns_name
  letsencrypt_registration_email = var.letsencrypt_registration_email
  load_balancer_id               = module.network.load_balancer_id
  leader                         = module.compute.leader
  workers                        = module.compute.workers
  debug_create_cluster_admin     = var.debug_create_cluster_admin
}
