cd terraform/app/frontends/green
terraform destroy -var voteapp_tag=0.1 -force
cd ../blue
terraform destroy -var voteapp_tag=0.1 -force

cd ../../backends
terraform destroy -force

cd ../../ecs
terraform destroy -force

cd ../consul
terraform destroy -force

cd ../vpc
terraform destroy -force

cd ../repo
terraform destroy -force
