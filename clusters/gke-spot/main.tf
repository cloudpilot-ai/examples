/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "google_client_config" "default" {}

provider "kubernetes" {
  host  = "https://${module.gke.endpoint}"
  token = data.google_client_config.default.access_token
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version = "~> 33.0"

  project_id               = var.PROJECT_ID
  name                     = var.CLUSTER_NAME
  region                   = var.region
  zones                    = var.zones
  network                  = var.network
  subnetwork               = var.subnetwork
  ip_range_pods            = var.ip_range_pods
  ip_range_services        = var.ip_range_services
  create_service_account   = false
  remove_default_node_pool = true
  deletion_protection      = false
  timeouts = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  node_pools = [
    {
      name         = "${var.CLUSTER_NAME}-nodepool"
      machine_type = "e2-standard-2"
      disk_type    = "pd-standard"
      node_count   = 2
      auto_upgrade = true
      spot         = true
    },
  ]
}
