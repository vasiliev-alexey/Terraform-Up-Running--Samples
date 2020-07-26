resource "google_compute_global_forwarding_rule" "web-frwd-rule" {
  name       = "web-frwd-rule"
  target     = google_compute_target_http_proxy.web-proxy.self_link
  port_range = "80"
  project    = var.project_name
}

resource "google_compute_target_http_proxy" "web-proxy" {
  name    = "web-proxy"
  project = var.project_name
  url_map = google_compute_url_map.web-url-map.self_link
}

resource "google_compute_url_map" "web-url-map" {
  name            = "web-url-map"
  project         = var.project_name
  default_service = google_compute_backend_service.web-service.self_link
}

resource "google_compute_backend_service" "web-service" {
  health_checks = [
    google_compute_http_health_check.web-hc.self_link
  ]
  name      = "web-service"
  port_name = "http"
  protocol  = "HTTP"
  project   = var.project_name
  backend {
    #group = google_compute_instance_group.web-group.self_link
    group = google_compute_instance_group_manager.default.instance_group
  }
}

resource "google_compute_http_health_check" "web-hc" {
  name    = "web-hc"
  port    = var.server_port
  project = var.project_name
}

