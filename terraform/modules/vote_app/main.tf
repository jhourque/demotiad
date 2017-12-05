variable "region" {
  type = "string"
}

variable "voteapp_repo" {
  type    = "string"
  default = "demotiad/vote"
}

variable "voteapp_tag" {
  type = "string"
}

variable "voteapp_count" {
  type    = "string"
  default = "2"
}

variable "color" {
  type = "string"
}

variable "log_group" {
  type = "string"
}

variable "cluster" {
  type = "string"
}

variable "bridge_ip" {
  type    = "string"
  default = "172.17.0.1"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

data "template_file" "voteapp" {
  template = "${file("${path.module}/files/voteapp.tpl.json")}"

  vars {
    TF_ACCOUNT   = "${data.aws_caller_identity.current.account_id}"
    TF_REGION    = "${var.region}"
    TF_REPO      = "${var.voteapp_repo}"
    TF_TAG       = "${var.voteapp_tag}"
    TF_BRIDGE_IP = "${var.bridge_ip}"
    TF_COLOR     = "${var.color}"
    TF_LOG_GROUP = "${var.log_group}"
  }
}

resource "aws_ecs_task_definition" "voteapp" {
  family                = "voteapp${var.color}"
  container_definitions = "${data.template_file.voteapp.rendered}"
}

resource "aws_ecs_service" "voteapp" {
  name            = "voteapp${var.color}"
  cluster         = "${var.cluster}"
  task_definition = "${aws_ecs_task_definition.voteapp.arn}"
  desired_count   = "${var.voteapp_count}"
}
