terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Rede própria pra os containers se enxergarem por nome (cadvisor, prometheus, etc.)
resource "docker_network" "devops" {
  name = "devops-net"
}

# ========== APP (Hello World) ==========
resource "docker_image" "hello" {
  name = "hello-devops:tf"

  build {
    context = "${path.module}/../app"
  }
}

resource "docker_container" "web" {
  name  = "web-hello"
  image = docker_image.hello.image_id

  networks_advanced {
    name = docker_network.devops.name
  }

  ports {
    internal = 80
    external = 8080
  }
}

# ========== MONITORAMENTO ==========
# cAdvisor: métricas de containers
resource "docker_image" "cadvisor" {
  name = "gcr.io/cadvisor/cadvisor:latest"
}

resource "docker_container" "cadvisor" {
  name  = "cadvisor"
  image = docker_image.cadvisor.image_id

  networks_advanced {
    name = docker_network.devops.name
  }

  ports {
    internal = 8080
    external = 8081
  }

  # mounts necessários pro cAdvisor ler métricas do host/containers
  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }
  volumes {
    host_path      = "/var/run"
    container_path = "/var/run"
    read_only      = true
  }
  volumes {
    host_path      = "/sys"
    container_path = "/sys"
    read_only      = true
  }
  volumes {
    host_path      = "/var/lib/docker"
    container_path = "/var/lib/docker"
    read_only      = true
  }
}

# Prometheus: coleta métricas do cAdvisor
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.image_id

  networks_advanced {
    name = docker_network.devops.name
  }

  ports {
    internal = 9090
    external = 9090
  }

  # monta o prometheus.yml
  volumes {
    host_path      = "${abspath(path.module)}/../monitoring/prometheus.yml"
    container_path = "/etc/prometheus/prometheus.yml"
    read_only      = true
  }

  command = [
    "--config.file=/etc/prometheus/prometheus.yml"
  ]
}

# Grafana: dashboards
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.image_id

  networks_advanced {
    name = docker_network.devops.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=admin"
  ]
}
