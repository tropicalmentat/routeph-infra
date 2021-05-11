terraform plan
echo "yes" | terraform apply
. add_hosts.sh
ansible-playbook --private-key /home/rowt_admin/.ssh/id_rsa -i hosts config-hosts.yml
ansible-playbook --private-key /home/rowt_admin/.ssh/id_rsa -i hosts config-vpc.yml
ansible-playbook --private-key /home/rowt_admin/.ssh/id_rsa -i hosts config-db.yml
ansible-playbook --private-key /home/rowt_admin/.ssh/id_rsa -i hosts config-route_engine.yml
ansible-playbook --private-key /home/rowt_admin/.ssh/id_rsa -i hosts config-reverse_proxy.yml
