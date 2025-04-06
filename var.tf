variable "app_name" {
  description = "Name of the application that the VM is running"
}

variable "target_size" {
  type = number
  description = "Number of instances"
}

variable "machine_type" {
  description = "e2-micro, n2-standard-2, etc."
}

variable "network_id" {
}

variable "subnetwork_id" {
}

variable "tags" {
  description = "These are used to connect the VMs to the GCP firewall rules"
  type = list(string)
}

variable "lb_ip_address" {
  description = "Normally set to the address of a GCP LB google_compute_global_address.abc.address"
}

variable "fwd_rule_port" {
  description = "Normally set to the address of a GCP LB google_compute_global_address.abc.address"
}

variable "source_image" {
  description = "ubuntu-os-cloud/ubuntu-2204-lts, etc."
}

