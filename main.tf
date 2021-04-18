provider digitalocean {
    token = var.do_token
    version = "2.7.0"
}

variable do_token {}

resource "digitalocean_project" "sandbox" {
   name="rowt-sandbox"
   resources=[digitalocean_droplet.gateway.urn,
              digitalocean_droplet.api.urn,
              digitalocean_droplet.gh.urn,
              digitalocean_droplet.db.urn]
}

resource "digitalocean_droplet" "gateway" {
   name="rowt-dev-db"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-1vcpu-1gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
}

resource "digitalocean_droplet" "api" {
   name="rowt-dev-api"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-1vcpu-1gb"
   vpc_uuid=digitalocean_vpc.sandbox.id

}

resource "digitalocean_vpc" "sandbox" {
   name="rowt-dev-vpc"
   region="sgp1"
}

resource "digitalocean_droplet" "gh" {
   name="rowt-dev-gh"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-2vcpu-4gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
}

resource "digitalocean_droplet" "db" {
   name="rowt-dev-db"
   image="ubuntu-20-04-x64"
   region="sgp1"
   size="s-1vcpu-1gb"
   vpc_uuid=digitalocean_vpc.sandbox.id
}
