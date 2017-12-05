variable "region" {
  type = "string"
}

variable "state_bucket" {
  type = "string"
}

variable "ecs_state_key" {
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
  type    = "string"
  default = "blue"
}

provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "ecs" {
  backend = "s3"

  config {
    bucket = "${var.state_bucket}"
    key    = "${var.ecs_state_key}"
    region = "${var.region}"
  }
}


module vote_app {
  source = "../../../modules/vote_app"

  region        = "${var.region}"
  voteapp_repo  = "${var.voteapp_repo}"
  voteapp_tag   = "${var.voteapp_tag}"
  voteapp_count = "${var.voteapp_count}"
  color         = "${var.color}"
  log_group     = "${data.terraform_remote_state.ecs.log_group}"
  cluster       = "${data.terraform_remote_state.ecs.cluster}"
}
