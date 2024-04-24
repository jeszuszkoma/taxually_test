#########################################
#              Variables                #
#########################################

variable "resource_group_name" {
  type = string
  default = "Test"
}

variable "location" {
  type = string
  default = "West Europe"
}

#Environment Diff names
variable "environmentName" {
  type = string
  default = "dev"
}

# For Tags etc you can use the Env Type
variable "environmentType" {
  type = string
  default = "Dev"
}

variable "project" {
  type = string
  default = "testxam"
}

# Def is B1 but you can scale it up if it needs
variable "app_service_plan" {
  type = string
  default = "B1"
}

variable "sql_admin" {
  type = string
  default = "4dm1n1str4t0r"
}

variable "sql_admin_password" {
  type = string
  default = "SuP3rS3cr3tP4ssw0rd"
}

variable "testxam_servicebus_namespace" {
  type = string
  default = "testxamnamespace"
}

variable "testxam_servicebus_queue" {
  type = string
  default = "testxamqueue"
}