locals {
  startup_script_path = "./startup-script.sh"
  startup_script_content = file(local.startup_script_path)
}

//================================================================================
// Instance Template
//================================================================================
resource "google_compute_instance_template" "cg_instance_template" {
  name = "${var.app_name}-template"
  machine_type = var.machine_type

  tags = var.tags
  
  disk {
    boot         = true
    source_image = var.source_image
  }

  network_interface {
    network = var.network_id
    subnetwork = var.subnetwork_id
  }

  metadata = {
    startup-script = local.startup_script_content
  }

  lifecycle {
    create_before_destroy = true
  }
}


//================================================================================
// MIG
//================================================================================
resource "google_compute_instance_group_manager" "gc_instance_group_manager1" {
  name = "${var.app_name}"
  base_instance_name = "${var.app_name}"
  version {
    instance_template = google_compute_instance_template.cg_instance_template.self_link
  }
  target_size = var.target_size
  

}


//================================================================================
// Load Balancer Stuff
//================================================================================
resource "google_compute_backend_service" "gc_backend_service" {
  name = "${var.app_name}-backend"
  protocol              = "TCP"
  health_checks         = [google_compute_health_check.gchc1.self_link]
  # health_checks         = var.health_checks
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = google_compute_instance_group_manager.gc_instance_group_manager1.instance_group
  }
}

resource "google_compute_target_tcp_proxy" "gc_target_tcp_proxy" {
  name = "${var.app_name}-proxy"
  backend_service = google_compute_backend_service.gc_backend_service.self_link
}

resource "google_compute_global_forwarding_rule" "gc_fwd_rule" {
  name = "${var.app_name}-fwd-rule"
  target     = google_compute_target_tcp_proxy.gc_target_tcp_proxy.self_link
  port_range = var.fwd_rule_port
  ip_address = var.lb_ip_address
}


resource "google_compute_health_check" "gchc1" {
  name = "${var.app_name}-health-check"
  tcp_health_check {
    port = 80
  }
}