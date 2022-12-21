terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.102.0"
    }
    null = {
      version = "3.1.0"
    }
  }
}

provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key_path     = var.private_key_path
  private_key_password = var.private_key_password
  region               = var.region
}
