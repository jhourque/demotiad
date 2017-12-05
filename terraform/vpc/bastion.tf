variable bastion_ami {
  type = "map"

  default {
    distrib = "debian"
    version = "debian-8"
  }
}

variable bastion_instance_type {
  type    = "string"
  default = "t2.micro"
}

variable "bastion_name" {
  type    = "string"
  default = "bastion"
}

variable "bastion_ttl" {
  type    = "string"
  default = "300"
}

resource "aws_key_pair" "tiad_keypair" {
  key_name   = "aws-tiadev"
  public_key = "${file("~/.ssh/id_rsa.tiad.pub")}"
}

module "ami" {
  source = "../modules/ami"
}

data "aws_ami" "bastion" {
  most_recent = true

  filter {
    name   = "name"
    values = "${list(module.ami.basenames[var.bastion_ami["version"]])}"
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = "${list(module.ami.owners[var.bastion_ami["distrib"]])}"
}

module "bastion" {
  source = "../modules/instances"
  name   = ["bastion"]

  ami_id          = "${data.aws_ami.bastion.id}"
  type            = "${var.bastion_instance_type}"
  key             = "${aws_key_pair.tiad_keypair.id}"
  subnet          = "${module.base_network.public_subnets}"
  security_groups = ["${module.base_network.sg_remote_access}", "${module.base_network.sg_admin}"]

  private_zone_id = "${module.private_dns.private_host_zone}"
  reverse_zone_id = "${module.private_dns.private_host_zone_reverse}"
  domain_name     = "${module.private_dns.private_domain_name}"
}

resource "aws_eip" "bastion" {
  instance = "${module.bastion.id[0]}"
  vpc      = true
}

output "bastion_ip" {
  value = "${aws_eip.bastion.public_ip}"
}
