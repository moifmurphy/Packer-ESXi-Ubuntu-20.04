# Pay special attention to the sections that contain the string CHANGEME - these are the bits that are specific to your environment / preferences

# Variables - called in the variables.pkvars.hcl file

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

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source

source "vmware-iso" "moiflab-ub01" {

# Boot Commands - here, we're starting a local HTTP server on our bootstrap machine to serve the user-data file containing the cloud-init instructions

  boot_command           = ["<enter><enter><f6><esc><wait> ", "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/", "<enter><wait>"]
  boot_wait              = "3s"

# Initial VM Specifications

  disk_size              = 40000
  disk_type_id           = "thin"
  guest_os_type          = "ubuntu-64"
  keep_registered        = true
  skip_export            = true

# Directories for user-data, meta-data and where to save the VM, locally (if required)

  http_directory         = "http"
  output_directory       = "output"

# ISO details - amend accordingly
  
  iso_checksum           = "28ccdb56450e643bad03bb7bcf7507ce3d8d90e8bf09e38f6bd9ac298a98eaad"
  iso_urls               = [
    "ubuntu-20.04.4-live-server-amd64.iso",
    "https://ftp.caliu.cat/pub/distribucions/ubuntu/releases/focal/ubuntu-20.04.4-live-server-amd64.iso"
  ]

# Remote details eg: how to connect to ESXi - values are changed in the variables.pkvars.hcl file, not here

  remote_cache_datastore = "${var.remote_cache_datastore}"
  remote_datastore       = "${var.remote_datastore}"
  remote_host            = "${var.remote_host}"
  remote_password        = "${var.remote_password}"
  remote_type            = "${var.remote_type}"
  remote_username        = "${var.remote_username}"

  shutdown_command       = "sudo shutdown -P now"

# SSH details once the VM has completed cloud-init

  ssh_handshake_attempts = 2000
  ssh_password           = "CHANGEME"
  ssh_pty                = true
  ssh_timeout            = "30m"
  ssh_username           = "CHANGEME"

# Actual VM data - ethernet0.networkName is the name of your portgroup, it might be VMNetwork.

  vmx_data = {
    "ethernet0.addressType"    = "generated"
    "ethernet0.networkName"    = "CHANGEME"
    "ethernet0.present"        = "TRUE"
    "ethernet0.startConnected" = "TRUE"
    "ethernet0.virtualDev"     = "vmxnet3"
    "ethernet0.wakeOnPcktRcv"  = "FALSE"
    memsize                    = "1024"
    numvcpus                   = "1"
  }

# We're connecting over websocket (VM Console)

  vnc_over_websocket     = true
  insecure_connection    = true
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build

build {
  sources = ["source.vmware-iso.moiflab-ub01"]

  provisioner "shell" {
    inline = ["ls /"]
  }

}  
