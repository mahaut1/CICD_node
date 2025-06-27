terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Configure the docker provider
provider "docker" {
}

# Create internal network for app communication
resource "docker_network" "internal_network" {
  name = "cicd-node-network"
}

# MongoDB container image
resource "docker_image" "mongodb" {
  name = "mongo:7.0"
}

# MongoDB container
resource "docker_container" "mongodb" {
  name  = "mongodb"
  image = docker_image.mongodb.image_id
  
  networks_advanced {
    name = docker_network.internal_network.name
  }
  
  env = [
    "MONGO_INITDB_ROOT_USERNAME=",
    "MONGO_INITDB_ROOT_PASSWORD=",
    "MONGO_INITDB_DATABASE=cicd_node_db"
  ]
  
  volumes {
    host_path      = 
    container_path = 
  }
  
  ports {
    internal = 27017
    external = 27017
  }
  
  restart = "always"
}

# Node.js API image
resource "docker_image" "node-api" {
  name         = "node-api"
  keep_locally = true
  build {
    context = "."
    dockerfile = "Dockerfile"
  }
}

# Node.js API container
resource "docker_container" "node-api" {
  name = "node-api"
  
  networks_advanced {
    name = docker_network.internal_network.name
  }
  
  image = docker_image.node-api.image_id
  
  env = [
    "PORT=8000",
    "MONGODB_URL=
  ]
  
  ports {
    external = 8000
    internal = 8000
  }
  
  restart = "always"
}

