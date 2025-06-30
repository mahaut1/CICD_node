variable "MYSQL_ROOT_PASSWORD" {
  type      = string
  sensitive = true
}

variable "MYSQL_DATABASE" {
  type = string
}

variable "REACT_APP_API_URL" {
  type = string
}

variable "MONGODB_URL" {
  type      = string
  sensitive = true
}

variable "PORT" {
  type = string
}
