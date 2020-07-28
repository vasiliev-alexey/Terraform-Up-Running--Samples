terraform {
  required_version = ">= 0.12.26"
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = "0.0.0.0/0"
}


resource "google_compute_instance" "example" {
  name         = "${var.instance_name}"
  machine_type = var.machine_type
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
nohup busybox httpd -f -p ${var.server_port} &
EOF

  lifecycle {
    create_before_destroy = true
  }


}


resource "google_compute_firewall" "default" {
  name        = "test-firewall"
  description = "Фаерволл: открываем порты для Веб-сервера , ssh, icmp"
  network     = google_compute_network.default.name



  allow {
    protocol = "tcp"
    ports    = [var.server_port, "22"]
  }


  allow {
    protocol = "icmp"

  }
  source_ranges = [
    local.all_ips
  ]

  target_tags = ["web"]
}

resource "google_compute_network" "default" {
  name = "test-network"

}