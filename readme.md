created-date: 4/4/2025
created-by: Matt Shirilla
Loadbalancer and associated resources with MIGs.



```tf
module "nginx_mig" {
  source         = "./modules/mig-with-lb"
  app_name = "abcc"
  network_id = google_compute_network.vpc1.id
  subnetwork_id = google_compute_subnetwork.subservers.id
  target_size = 1
  lb_ip_address = google_compute_global_address.lb_ip.address
  fwd_rule_port = "8001"
  machine_type = "e2-micro"
  source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
  tags = ["main-net-tag"]
}
```
