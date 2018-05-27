variable "project" {
  description = "Proyecto en el que desplegar"
  type        = "string"
}

variable "zone" {
  description = "Zona en la que desplegar"
  type        = "string"
}

variable "bastion_machine_type" {
  description = "Tamaño de la maquina"
  type        = "string"
}


variable "machine_type" {
  description = "Tamaño de la maquina"
  type        = "string"
}


variable "image" {
  description = "Imagen del sistema operativo"
  type        = "string"
}


variable "master_count" {
  description = "Cantidad de maquinas"
  type        = "string"
}

variable "infra_count" {
  description = "Cantidad de maquinas"
  type        = "string"
}


variable "node_count" {
  description = "Cantidad de maquinas"
  type        = "string"
}
