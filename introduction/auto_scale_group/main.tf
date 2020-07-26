

terraform {
  required_version = ">= 0.12.26"
}

provider "google-beta" {
  region = var.region_name
  zone   = var.location_name
}


resource "google_compute_autoscaler" "default" {
  provider = google-beta
  project  = var.project_name
  name     = "my-autoscaler"
  zone     = var.location_name
  target   = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    metric {
      name                       = "pubsub.googleapis.com/subscription/num_undelivered_messages"
      filter                     = "resource.type = pubsub_subscription AND resource.label.subscription_id = our-subscription"
      single_instance_assignment = 65535
    }
  }
}


# шаблон создаваемых машин
resource "google_compute_instance_template" "default" {
  provider       = google-beta
  description    = "Шаблон для создания VM"
  name           = "default"
  machine_type   = var.machine_type
  can_ip_forward = false
  project        = var.project_name

  tags = ["tst-change", "terraform", "web"]


  disk {
    boot         = true
    disk_size_gb = "20"
    disk_type    = "pd-standard"
    source_image = data.google_compute_image.ubuntu.self_link


  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = <<-EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p ${var.server_port} &
EOF

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }


  scheduling {
    preemptible       = true
    automatic_restart = false
  }

}

# Пул машин
resource "google_compute_target_pool" "default" {
  provider = google-beta
  name     = "my-target-pool"
  project  = var.project_name
}

#  менеджер пула машин
resource "google_compute_instance_group_manager" "default" {
  provider = google-beta
  project  = var.project_name
  name     = "my-igm"
  zone     = var.location_name

  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }

  target_pools       = [google_compute_target_pool.default.id]
  base_instance_name = "autoscaler-sample"


 named_port {
    name = "http"
    port = var.server_port
  }

}

data "google_compute_image" "ubuntu" {
  provider = google-beta

  family  = "ubuntu-2004-lts"
  project = "ubuntu-os-cloud"
}



