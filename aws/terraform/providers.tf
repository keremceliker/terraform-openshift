# Configure the AWS Provider
variable "aws_access_key" {
  description = "Access Key"
  type        = "string"
}

variable "aws_secret_key" {
  description = "Secret Key"
  type        = "string"
}


provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}
