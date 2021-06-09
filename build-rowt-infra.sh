rm facts/*
terraform plan
echo "yes" | terraform apply
echo "Wait for 15s before next step"
sleep 15s
. add_hosts.sh
ansible-playbook --private-key /home/$USER/.ssh/id_rsa -i hosts config-hosts.yml
ansible-playbook --private-key /home/$USER/.ssh/id_rsa -i hosts config-vpc.yml
ansible-playbook --private-key /home/$USER/.ssh/id_rsa -i hosts config-db.yml
ansible-playbook --private-key /home/$USER/.ssh/id_rsa -i hosts config-route_engine.yml
ansible-playbook --private-key /home/$USER/.ssh/id_rsa -i hosts config-reverse_proxy.yml
ansible-playbook --private-key /home/$USER/.ssh/id_rsa -i hosts config-api.yml
ansible-playbook --private-key /home/$USER/.ssh/id_rsa -i hosts config-backend.yml
