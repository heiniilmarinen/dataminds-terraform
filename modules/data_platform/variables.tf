variable "name" {
  description = "The base for the name"
}

variable "rg_name" {
  description = "Resource group name"
}

variable "location" {
  description = "Location for the resources"
}

variable "create_dl" {
  type = bool
}

variable "sql_admin" {
  description = "The Azure AD SQL admin account"
  type = string
}