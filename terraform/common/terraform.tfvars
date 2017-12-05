region = "eu-central-1"

cidr_block =           "10.40.0.0/16"
subnet_public_block =  "10.40.0.0/17"
subnet_private_block = "10.40.128.0/17"

vpc_name = "DEMO DD"

domain = "demo.dd"

key_name = "aws-tiadev"
state_bucket = "tiad-tfstate"
vpc_state_key = "vpc.tfstate"
consul_state_key = "consul.tfstate"
ecs_state_key = "ecs.tfstate"
dns_alias = "dday"

consul_version ="0.7.0"
