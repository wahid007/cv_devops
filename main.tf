terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "moncv_image" {
  name         = "wahidh007/cv-devops"
  keep_locally = false
}

resource "docker_container" "moncv_container" {
  name  = "moncv"
  image = docker_image.moncv_image.image_id

  ports {
    internal = 80
    external = 8585
  }
}
output "container_id" {
  value = docker_container.moncv_container.id
}
