variable "compartment_id" { type = string }
variable "ssh_key_path" { type = string }
variable "ssh_key_pub_path" { type = string }

variable "leader" {
  type = object({
    shape                       = string
    image                       = string
    ocpus                       = number
    memory_in_gbs               = number
    hostname                    = string
    subnet_id                   = string
    overwrite_local_kube_config = bool
  })
}

variable "workers" {
  type = object({
    count         = number
    shape         = string
    image         = string
    ocpus         = number
    memory_in_gbs = number
    base_hostname = string
    subnet_id     = string
  })
}
