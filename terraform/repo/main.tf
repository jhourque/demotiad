variable "region" {
  type = "string"
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_ecr_repository" "vote" {
  name = "demotiad/vote"
}

resource "aws_ecr_repository" "dynnginx" {
  name = "demotiad/dynnginx"
}

resource "aws_ecr_repository" "dynhaproxy" {
  name = "demotiad/dynhaproxy"
}

output "ecr_vote_id" {
  value = "${aws_ecr_repository.vote.registry_id}"
}

output "ecr_dynnginx_id" {
  value = "${aws_ecr_repository.dynnginx.registry_id}"
}

output "ecr_dynhaproxy_id" {
  value = "${aws_ecr_repository.dynhaproxy.registry_id}"
}

output "ecr_vote_url" {
  value = "${aws_ecr_repository.vote.repository_url}"
}

output "ecr_dynnginx_url" {
  value = "${aws_ecr_repository.dynnginx.repository_url}"
}

output "ecr_dynhaproxy_url" {
  value = "${aws_ecr_repository.dynhaproxy.repository_url}"
}
