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
   resources=[digitalocean_droplet.gateway.urn,
              digitalocean_droplet.api.urn,
              digitalocean_droplet.gh.urn,
              digitalocean_droplet.db.urn]
}

resource "digitalocean_vpc" "sandbox" {
   name="rowt-dev-vpc"
   region="sgp1"
}

resource "digitalocean_ssh_key" "admin" {
   name="rowt admin"
   public_key=file(var.pubkey_path)
}

resource "digitalocean_droplet" "gateway" {
   name="rowt-dev-gw"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-1vcpu-1gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
   ssh_keys=[digitalocean_ssh_key.admin.fingerprint]

   provisioner "remote-exec" {
     inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]
  
     connection {
       host=self.ipv4_address
       type="ssh"
       user="root"
       private_key=file(var.pvtkey_path)
     }
   }
  
   provisioner "local-exec" {
     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvtkey_path} -e 'pubkey_path=${var.pubkey_path}' config-hosts.yml"
   }  

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

output "ssh_public_key" {
   value=digitalocean_ssh_key.admin.public_key
   sensitive=true
}
