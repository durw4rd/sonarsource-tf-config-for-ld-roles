terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.18.4"
    }
  }
  required_version = "~> 1.9.0"
}

# Configure the LaunchDarkly provider
provider "launchdarkly" {
  access_token = var.launchdarkly_access_token
}

variable "launchdarkly_access_token" {
  type        = string
  sensitive   = true
  description = "LaunchDarkly access token"
}

variable "squad_names" {
  type    = list(string)
  default = ["Integration", "Billing", "Identity", "Experience", "Dev_Workflow", "Enterprise", "Reporting", "Platform"] 
}

resource "launchdarkly_custom_role" "squad_roles" {
  for_each = toset(var.squad_names)

  key         = "${each.key}-squad-role"
  name        = "${each.key} squad role"
  description = "Role for the ${each.key} squad"
  base_permissions  = "reader"

  policy_statements {
    resources = [
      "application/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "code-reference-repository/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "integration/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:env/*:destination/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "service-token/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:context-kind/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "member/*:token/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*"
    ]
    actions = [
      "viewSdkKey"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*:experiment/*",
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*:holdout/*",
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:layer/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*:flag/${each.key}-*",
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:env/*:flag/*",
    ]
    actions = [
      "bypassRequiredApproval"
    ]
    effect = "deny"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*:segment/*",
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:metric/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:metric-group/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "template/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:release-pipeline/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "webhook/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }
}

resource "launchdarkly_team" "squad_teams" {
  for_each = toset(var.squad_names)

  key         = "${each.key}-squad-team"
  name        = "${each.key} squad team"
  description = "Team for ${each.key} squad"

  custom_role_keys = [
    "${each.key}-role"
  ]

  # ignore changes to team membership to avoid overwriting IDP assignments
  lifecycle {
    ignore_changes = [member_ids]
  }
}
