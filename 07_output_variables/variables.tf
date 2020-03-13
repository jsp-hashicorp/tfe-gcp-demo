# If no type is specified, then Terraform assumes a variable is a string. 
variable "project" {
  type = string
  default = "hc-jsp-gcp-test"
}

# Path is relative to the location where terraform is running.
#variable "credentials_file" {
  #default = "hc-jsp.json"
#}

variable "service_account_key" {
  # default = "hc-gcp.json"
  type = string
}

variable "region" {
  default = "asia-northeast3"
}

variable "zone" {
  default = "asia-northeast3-c"
}

variable "environment" {
  type = string 
  default = "dev"
}

variable "machine_types" {
  type = map
  default = {
    "dev" = "f1-micro"
    "test"  = "n1-standard-2"
    "prod"  = "n1-standard-4"
  }
}
