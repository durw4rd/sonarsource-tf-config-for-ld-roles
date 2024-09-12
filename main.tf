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
  default = ["integration", "billing", "identity", "experience", "dev-workflow", "enterprise", "reporting", "platform"] 
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
      "proj/sonarcloud:env/*:destination/*",
      "proj/sandbox:env/*:destination/*"
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
      "proj/sonarcloud:context-kind/*",
      "proj/sandbox:context-kind/*"
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
      "proj/sonarcloud",
      "proj/sandbox"
    ]
    actions = [
      "updateDefaultClientSideAvailability", 
      "updateIncludeInSnippetByDefault",
      "updateProjectFlagDefaults",
      "updateTags",
      "updateDefaultReleasePipeline"
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
      "proj/sandbox:env/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*:experiment/*",
      "proj/sandbox:env/*:experiment/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*:holdout/*",
      "proj/sandbox:env/*:holdout/*",
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:layer/*",
      "proj/sandbox:layer/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:env/*:flag/${each.key}-*",
      "proj/sandbox:env/*:flag/*",
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
      "proj/sandbox:env/*:segment/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:metric/*",
      "proj/sandbox:metric/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/sonarcloud:metric-group/*",
      "proj/sandbox:metric-group/*"
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
      "proj/sonarcloud:release-pipeline/*",
      "proj/sandbox:release-pipeline/*"
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
    "${each.key}-squad-role"
  ]

  # ignore changes to team membership to avoid overwriting IDP assignments
  lifecycle {
    ignore_changes = [member_ids]
  }
}
