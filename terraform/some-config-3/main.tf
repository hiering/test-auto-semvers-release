locals {
  terraform_tag = [{
    key   = "terraform"
    value = "true"
  }]
}

resource "awscc_networkmanager_global_network" "main" {
  description = "My Global Network"
  tags = concat(local.terraform_tag,
    [{
      key   = "Name"
      value = "My Global Network"
    }]
  )
}