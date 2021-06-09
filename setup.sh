# Install terraform v0.12.12
wget https://releases.hashicorp.com/terraform/0.12.12/terraform_0.12.12_linux_amd64.zip
unzip terraform_0.12.12_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Install ansible
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# Copy repo
git clone https://gitlab.com/tropicalmentat/rowt-infra.git
