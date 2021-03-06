provider "google" {
  #credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
  credentials = var.service_account_key
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-jsp-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-jsp-instance"
  machine_type = var.machine_types[var.environment]
  tags         = ["dev", "test", "prod"]

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
  name  = "tf-example-bucket-jsp-20200313"
  location = "ASIA"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "another_instance" {
  depends_on = [google_storage_bucket.example_bucket]
  
  count = var.num
  name         = "tf-instance-${count.index}"
  machine_type = "f1-micro"
  #machine_type = "g1-small"

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
