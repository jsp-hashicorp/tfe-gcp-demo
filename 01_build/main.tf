provider "google" {
  credentials = file("hc-jsp-gcp-test-94d796ce3b58.json")

  project = "hc-jsp-gcp-test"
  region  = "asia-northeast3"
  zone    = "asia-northeast3-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-jsp-network"
}

