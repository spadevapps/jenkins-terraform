terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "flaskapp"
    labels = {
      App = "flaskapp"
    }
  }
  spec {
    replicas =4
    selector {
      match_labels = {
        App = "flaskapp"
      }
    }
    template {
      metadata {
        labels = {
          App = "flaskapp"
        }
      }
      spec {
        container {
          image = "spadevapps/sba.kubernetes-cluster"
          name  = "flaskapp"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "flaskapp" {
  metadata {
    name = "flaskapp"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flaskapp.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
