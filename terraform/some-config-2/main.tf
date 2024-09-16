resource "awscc_networkmanager_core_network" "main" {
  description       = "My Core Network"
  global_network_id = awscc_networkmanager_global_network.main.id
  # Compose jsonencode and jsondecode to produce a normalized JSON string.
  policy_document = jsonencode(jsondecode(data.aws_networkmanager_core_network_policy_document.main.json))
  tags            = local.terraform_tag
}

data "aws_networkmanager_core_network_policy_document" "main" {
  core_network_configuration {
    vpn_ecmp_support = false
    asn_ranges       = ["64512-64555"]
    edge_locations {
      location = "us-east-1"
      asn      = 64512
    }
  }

  segments {
    name                          = "shared"
    description                   = "SegmentForSharedServices"
    require_attachment_acceptance = true
  }

  segment_actions {
    action     = "share"
    mode       = "attachment-route"
    segment    = "shared"
    share_with = ["*"]
  }

  attachment_policies {
    rule_number     = 1
    condition_logic = "or"

    conditions {
      type     = "tag-value"
      operator = "equals"
      key      = "segment"
      value    = "shared"
    }
    action {
      association_method = "constant"
      segment            = "shared"
    }
  }
}