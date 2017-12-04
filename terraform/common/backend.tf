terraform {
  backend "s3" {
    bucket = "tiad-tfstate"
    region = "eu-central-1"
  }
}
