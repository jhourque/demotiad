cd terraform/repo
./init
terraform apply -auto-approve

# Get repos for docker
vote=$(terraform output ecr_vote_url)
dynnginx=$(terraform output ecr_dynnginx_url)
dynhaproxy=$(terraform output ecr_dynhaproxy_url)

cd ../vpc
./init
terraform apply -auto-approve

# Get VPC & Subnet for packer
VPC_ID=$(terraform output vpc_id)
SUBNET_ID=$(terraform output public_subnets |tail -n 1)

#### Docker ####
cd ../..

# Build images
docker build -t demotiad/vote:0.1 --build-arg version=0.1 docker/vote
docker build -t demotiad/dynnginx dynnginx
docker build -t demotiad/dynhaproxy dynhaproxy

# Tag images
docker tag demotiad/vote:0.1 demotiad/vote:latest
docker tag demotiad/vote:0.1 ${vote}:0.1
docker tag demotiad/vote:latest ${vote}:latest
docker tag demotiad/dynnginx:latest ${dynnginx}:latest
docker tag demotiad/dynhaproxy:latest ${dynhaproxy}:latest

# Push images to repo
$(aws ecr get-login | sed "s/-e none//")
docker push ${vote}:0.1
docker push ${vote}:latest
docker push ${dynnginx}:latest
docker push ${dynhaproxy}:latest

#### Packer ####
cd packer/consul-server
# Build AMI
packer build -var-file=debian.params.json consul.json

#### Terraform ####
cd ../../terraform/consul
./init
terraform apply -auto-approve

cd ../ecs
./init
terraform apply -auto-approve

cd ../app/backends
./init
terraform apply -auto-approve

cd ../frontends/blue
./init
terraform apply -var voteapp_tag=0.1 -auto-approve

cd ../green
./init
terraform apply -var voteapp_tag=0.1 -auto-approve
