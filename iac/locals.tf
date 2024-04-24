#########################################
#               LOCALS                  #
#########################################

locals {
  common_tags = {
    Env = var.environmentName
    App = var.project
  }
}