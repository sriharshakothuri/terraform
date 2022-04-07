terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.16.0"
    }
  }
}

resource "google_compute_instance" "default" {
  name         = "jenkinsserver"
  machine_type = "n1-standard-2"
  zone         = "asia-south2-c"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

//   metadata = {
//     foo = "bar"
//   }

  metadata_startup_script = <<SCRIPT
  #!/bin/bash
  curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt-get update
  sudo apt-get install openjdk-11-jre -y
  sudo apt-get install jenkins -y
  SCRIPT

//   service_account {
//     # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
//     email  = google_service_account.default.email
//     scopes = ["cloud-platform"]
//   }
}

resource "google_container_cluster" "primary" {
  name     = "harsha-cluster"
  location = "asia-south2"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "asia-south2"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = "terraformsa@peerless-rock-346305.iam.gserviceaccount.com"
  }
}