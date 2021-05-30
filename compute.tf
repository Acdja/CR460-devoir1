resource "google_compute_instance" "vm_chien" {
  name         = "chien"
  machine_type = "f1-micro"
  zone         = var.zone

  tags = ["public","http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
      }
    }
  network_interface {
       subnetwork = google_compute_subnetwork.prod-dmz.name

    access_config {
      }
  }


metadata_startup_script = "apt-get -y update && apt-get -y upgrade && apt-get -y install apache2 && systemctl start apache2"


}

resource "google_compute_instance" "Vm_chat" {
  name = "chat"
  machine_type = "f1-micro"
  zone         = var.zone
  tags = ["interne"]
boot_disk {
  initialize_params {
    image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
     network_interface {
     subnetwork = google_compute_subnetwork.prod-interne.name
    access_config {
        }
    }
 }


 resource "google_compute_instance_template" "hamster" {
   name = "hamster"
   machine_type = "f1-micro"
   region         = "us-central1"
   tags = ["traitement"]
   can_ip_forward = "true"

 disk {
     source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
     auto_delete = "true"
     boot = "false"
     }

      network_interface {
      subnetwork = google_compute_subnetwork.prod-traitement.name
     access_config {
         }
     }
  }

  resource "google_compute_instance_group_manager" "hamster-gm" {
     name = "hamster-gm"
     base_instance_name = "worker"
     version {
       instance_template = google_compute_instance_template.hamster.self_link
       name = "primary"
       }
       zone = "us-central1-c"
   }


   resource "google_compute_autoscaler" "hamster-autoscaler" {
     name = "hamster-autoscaler"
     zone         = "us-central1-c"
     target = google_compute_instance_group_manager.hamster-gm.self_link

     autoscaling_policy {
       max_replicas = 5
       min_replicas = 1
       cooldown_period = 180

      cpu_utilization {
        target = 0.53
       }
     }

    }




    resource "google_compute_instance" "Vm_perroquet" {
      name = "perroquet"
      machine_type = "f1-micro"
      zone         = var.zone
      tags = ["cage"]
    boot_disk {
      initialize_params {
        image = "ubuntu-os-cloud/ubuntu-1604-lts"
        }
      }
         network_interface {
         network = "default"
        access_config {
            }
        }
     }



     resource "google_compute_health_check" "http-health-check" {
     name        = "http-health-check"
     description = "Health check via http"

     timeout_sec         = 1
     check_interval_sec  = 4
     healthy_threshold   = 5
     unhealthy_threshold = 3

     http_health_check {
       port_name          = "health-check-port"
       port_specification = "USE_NAMED_PORT"
       host               = "1.2.3.4"
       request_path       = "/mypath"
       proxy_header       = "NONE"
       response           = "I AM HEALTHY"
     }
   }
