variable "cluster_name" {}
variable "region" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
