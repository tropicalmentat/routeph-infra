# https://coffay.haus/pages/terraform+ansible
# https://alex.dzyoba.com/blog/terraform-ansible/
provider digitalocean {
    token = var.do_token
    version = "2.7.0"
}

variable do_token {
   type=string
}

variable "pubkey_path" {
   type=string
}

variable "pvtkey_path" {
  type=string
}

resource "digitalocean_project" "sandbox" {
   name="rowt-sandbox"
   resources=[digitalocean_droplet.bastion.urn,
              digitalocean_droplet.api.urn,
              digitalocean_droplet.gh.urn,
              digitalocean_droplet.db.urn]
}

resource "digitalocean_vpc" "sandbox" {
   name="rowt-dev-vpc"
   region="sgp1"
}

resource "digitalocean_ssh_key" "admin" {
   name="rowt_admin"
   public_key=file(var.pubkey_path)
}

resource "digitalocean_droplet" "bastion" {
   name="rowt-dev-gw"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-1vcpu-1gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
   ssh_keys=[digitalocean_ssh_key.admin.fingerprint]
}

resource "digitalocean_droplet" "api" {
   name="rowt-dev-api"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-1vcpu-1gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
   ssh_keys=[digitalocean_ssh_key.admin.fingerprint]
}

resource "digitalocean_droplet" "gh" {
   name="rowt-dev-gh"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-2vcpu-4gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
   ssh_keys=[digitalocean_ssh_key.admin.fingerprint]
}

resource "digitalocean_droplet" "db" {
   name="rowt-dev-db"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-1vcpu-1gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
   ssh_keys=[digitalocean_ssh_key.admin.fingerprint]
}

resource "local_file" "inventory" {
   filename="hosts"
   content=<<EOT
   ${digitalocean_droplet.bastion.ipv4_address}
   ${digitalocean_droplet.api.ipv4_address} 
   ${digitalocean_droplet.gh.ipv4_address}
   ${digitalocean_droplet.db.ipv4_address}
   EOT
}

resource "local_file" "host_script" {
   filename="./add_hosts.sh"
   content=<<EOT
   echo "Setting SSH Key"
   ssh-add /home/rowt_admin/.ssh/id_rsa
   echo "Adding IPs"

   ssh-keyscan -H ${digitalocean_droplet.bastion.ipv4_address} >> ~/.ssh/known_hosts
   ssh-keyscan -H ${digitalocean_droplet.api.ipv4_address} >> ~/.ssh/known_hosts
   ssh-keyscan -H ${digitalocean_droplet.gh.ipv4_address} >> ~/.ssh/known_hosts 
   ssh-keyscan -H ${digitalocean_droplet.db.ipv4_address} >> ~/.ssh/known_hosts

   EOT
}

output "ssh_public_key" {
   value=digitalocean_ssh_key.admin.public_key
   sensitive=true
}
