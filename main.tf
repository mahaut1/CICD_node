terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  # Uses DOCKER_HOST environment variable if set, otherwise defaults to system default
  # For macOS Docker Desktop: export DOCKER_HOST=unix:///Users/$USER/.docker/run/docker.sock
  # For Linux: export DOCKER_HOST=unix:///var/run/docker.sock (or leave unset)
  # For Windows: varies by setup
}

# Réseau commun pour tous les conteneurs
resource "docker_network" "internal_network" {
  name = "app-network"
}

############################
# MYSQL
############################

resource "docker_image" "mysql" {
  name = "mysql:8.0"
}

resource "docker_container" "mysql" {
  name  = "mysql"
  image = docker_image.mysql.image_id
  networks_advanced {
    name = docker_network.internal_network.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${var.MYSQL_ROOT_PASSWORD}"
  ]

  volumes {
    host_path = abspath("${path.module}/SQLFiles")
    container_path = "/docker-entrypoint-initdb.d"
  }

  ports {
    internal = 3306
    external = 3306
  }

  restart = "always"
}

############################
# Adminer
############################

resource "docker_image" "adminer" {
  name = "adminer"
}

resource "docker_container" "adminer" {
  name  = "adminer"
  image = docker_image.adminer.image_id

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = docker_network.internal_network.name
  }

  restart = "always"
}

############################
# FASTAPI
############################

resource "docker_image" "fastapi" {
  name         = "fastapi-server"
  build {
    context    = "./src/serveur"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "fastapi" {
  name  = "fastapi"
  image = docker_image.fastapi.image_id

  ports {
    internal = 8000
    external = 8000
  }

  env = [
    "MYSQL_DATABASE=${var.MYSQL_DATABASE}",
    "MYSQL_HOST=mysql",
    "MYSQL_USER=root",
    "MYSQL_PASSWORD=${var.MYSQL_ROOT_PASSWORD}"
  ]

  networks_advanced {
    name = docker_network.internal_network.name
  }

  depends_on = [docker_container.mysql]

  restart = "always"
}

############################
# React
############################

resource "docker_image" "react" {
  name = "react-client"
  build {
    context    = "."
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "react" {
  name  = "react"
  image = docker_image.react.image_id

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "REACT_APP_API_URL=${var.REACT_APP_API_URL}"
  ]

  volumes {
    host_path = abspath("${path.module}")
    container_path = "/app"
  }

  volumes {
    host_path      = abspath("${path.module}/node_modules")
    container_path = "/app/node_modules"
  }

  networks_advanced {
    name = docker_network.internal_network.name
  }

  depends_on = [docker_container.fastapi]

  restart = "always"
}

############################
# MongoDB
############################

resource "docker_image" "mongo" {
  name = "mongo:7.0"
}

resource "docker_container" "mongo" {
  name  = "mongo"
  image = docker_image.mongo.image_id

  ports {
    internal = 27017
    external = 27017
  }

  networks_advanced {
    name = docker_network.internal_network.name
  }

  volumes {
    host_path = abspath("${path.module}/mongo-data")
    container_path = "/data/db"
  }

  restart = "always"
}

############################
# Node.js App
############################

resource "docker_image" "nodeapp" {
  name = "node-app"
  build {
    context    = "./node" # <-- change si nécessaire
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "nodeapp" {
  name  = "nodeapp"
  image = docker_image.nodeapp.image_id

  ports {
    internal = 8000
    external = 3001  # Changed from 8000 to 3001 to avoid conflict with FastAPI
  }

  env = [
    "PORT=${var.PORT}",
    "MONGODB_URL=${var.MONGODB_URL}"
  ]

  networks_advanced {
    name = docker_network.internal_network.name
  }

  depends_on = [docker_container.mongo]

  restart = "always"
}
