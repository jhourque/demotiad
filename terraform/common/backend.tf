terraform {
  backend "s3" {
    bucket = "tfdemo-tfstate"
    region = "eu-west-1"
  }
}
