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

  provisioner "local-exec" {
    command  = "echo ${google_compute_instance.vm_instance.name}: ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip  = google_compute_address.vm_static_ip.address
    }
  }
}

resource "google_compute_address" "vm_static_ip" {
  name  = "tf-jsp-static-ip"
}

resource "google_storage_bucket" "example_bucket" {
  name  = "tf-example-bucket-jsp-20200219"
  location = "ASIA"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "another_instance" {
  depends_on = [google_storage_bucket.example_bucket]
  
  name         = "tf-instance-2"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  
  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}
