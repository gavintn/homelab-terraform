terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

provider "proxmox" {
  insecure = true
}

resource "proxmox_virtual_environment_vm" "test" {
  name      = "tf-test"
  node_name = "pve"
  vm_id     = 9200

  clone {
    vm_id = 9000
    full  = true
  }

  agent {
    enabled = false
  }

  cpu {
    cores = 2
    type  = "x86-64-v2"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 20
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }
}