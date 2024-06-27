provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "web_app_namespace" {
  metadata {
    name = "web-app-namespace"
  }
}

resource "kubernetes_deployment" "nginx_deployment" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.web_app_namespace.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:3.14.0"
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.web_app_namespace.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx_deployment.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

