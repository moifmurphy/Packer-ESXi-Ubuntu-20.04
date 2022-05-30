# variables

# variables

variable "remote_host" {
  type        = string
  description = "The fully qualified domain name or IP address of the ESXi Server instance. (e.g. 'sfo-w01-vc01.sfo.rainpole.io')"
}

variable "remote_username" {
  type        = string
  description = "The username to login to the ESXi Server instance. (e.g. 'svc-packer-vmware@rainpole.io')"
}

variable "remote_password" {
  type        = string
  description = "The password for the login to the ESXi Server instance."
}

variable "remote_cache_datastore" {
  type        = string
  description = "Where to cache the ISOs"
}

variable "remote_datastore" {
  type        = string
  description = "Where to cache the ISOs"
}

variable "remote_type" {
  type        = string
  description = "ESXi version 5"
}