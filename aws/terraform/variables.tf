variable "region" {
  description = "Zona en la que desplegar"
  type        = "string"
}

variable "zone" {
  description = "Zona en la que desplegar"
  type        = "string"
}

variable "bastion_instance_type" {
  description = "Tamaño de la maquina"
  type        = "string"
}


variable "default_sg_name" {
  description = "Grupo por defecto de seguridad"
  type        = "string"
}


variable "security_groups" {
  description = "Nombres de los Security Groups"
  type        = "list"
}


variable "instance_type" {
  description = "Tamaño de la maquina"
  type        = "string"
}


variable "osdisk_size" {
  description = "Tamaño del disco de sistema"
  type        = "string"
}

variable "cidr_block" {
  description = "Redes"
  type        = "string"
}


variable "cidr_blocks" {
  description = "Subredes"
  type        = "list"
}


variable "image" {
  description = "Imagen del sistema operativo"
  type        = "string"
}

variable "key_name" {
  description = "Nombre de la clave RSA"
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


variable "cluster_id" {
  description = "ID del cluster"
  type        = "string"
}

variable "console_domain" {
  description = "URL para acceder a Openshift"
  type        = "string"
}

variable "hosted_zone" {
  description = "Zona DNS de Route 53"
  type        = "string"
}



###### LOAD Balancer
variable "elb_names" {
  description = "Nombre del Load Balancer"
  type        = "list"
}
