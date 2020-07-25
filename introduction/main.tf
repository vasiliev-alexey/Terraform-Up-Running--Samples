terraform {
  required_version = ">= 0.12.26"
}

provider "google" {
  version = "~> 3.15.0"
  project = var.project_name
  region  = var.region_name
  zone    = var.location_name
}


resource "google_compute_instance" "example" {
  name         = "test"
  machine_type = "f1-micro"
  description  = "Тестовая машина для GCP"

  depends_on = [google_compute_network.default]

  boot_disk {
    initialize_params {
      size  = "20"
      type  = "pd-standard"
      image = "ubuntu-os-cloud/ubuntu-2004-lts"

    }

    auto_delete = "true"
  }

  network_interface {
    network = "test-network"
    access_config {
    }

  }

  tags = ["tst-change", "terraform", "web"]

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  metadata_startup_script = <<-EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p 8080 &
EOF

}


resource "google_compute_firewall" "default" {
  name    = "test-firewall"
  network = google_compute_network.default.name



  allow {
    protocol = "tcp"
    ports    = ["8080", "22"]
  }


  allow {
    protocol = "icmp"

  }
  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "test-network"

}