provider "google" {
  credentials = file("hc-jsp-gcp-test-94d796ce3b58.json")

  project = "hc-jsp-gcp-test"
  region  = "asia-northeast3"
  zone    = "asia-northeast3-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-jsp-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-jsp-instance"
  machine_type = "f1-micro"
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      #image = "debian-cloud/debian-9"
    }
  }
  
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

