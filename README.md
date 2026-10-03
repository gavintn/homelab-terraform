\# homelab-terraform



Terraform config that clones a Debian cloud-init template on a Proxmox VE 9.2 host into a new VM.



\## What it does

\- Clones template VM 9000 (Debian 13 genericcloud) to a new VM

\- Resizes the disk to 20 GB, DHCP networking

\- SSH key and user come from the template's Cloud-Init settings



\## Measured

\- Destroy: \~4 s. Create: \~39-42 s (single VM, single runs, not a benchmark)

\- "Ready to use" takes longer: the guest agent isn't installed yet, so the new VM's IP has to be found manually



\## Setup

1\. Build the template (cloud image imported via the Proxmox GUI, Cloud-Init drive added, converted to template)

2\. Create a `terraform@pve` user and an API token (Privilege Separation off)

3\. Set credentials as environment variables, never in files:

&#x20;  - `PROXMOX\_VE\_ENDPOINT`

&#x20;  - `PROXMOX\_VE\_API\_TOKEN` (format `user@realm!tokenid=secret`)

4\. `terraform init \&\& terraform apply`



\## Permissions needed (found by hitting 403s)

| Path | Role | Why |

|---|---|---|

| `/` | PVEVMAdmin | create and manage VMs |

| `/storage/local-lvm` | PVEDatastoreUser | allocate disk space on clone |

| `/sdn/zones/localnetwork` | PVESDNUser | attach NIC to vmbr0 |



\## Gotchas

\- \*\*`host doesn't support requested feature: CPUID...aes`\*\*: the `x86-64-v2-AES` CPU type failed on my host. Use `x86-64-v2` or `kvm64`, on both the template and in `main.tf`.

\- \*\*Hang on apply\*\*: with no guest agent in the template, set `agent { enabled = false }`.

\- `.tfstate` can contain secrets. It is gitignored; keep it that way.



\## Next

\- Install qemu-guest-agent via Ansible

\- Deploy monitoring (Prometheus + Grafana) as the first Ansible target

