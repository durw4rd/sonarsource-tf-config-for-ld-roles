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

resource "launchdarkly_custom_role" "old_mutual_devs_example_tf" {
  key               = "old-mutual-devs-example-policy"
  name              = "Old Mutual: Devs Example Policy"
  description       = "Custom role for developers. Based on a restricted built-in Writer role with write access limited to 'dev' and 'int' environment resources."
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
      "member/*:token/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:env/dev:experiment/*",
      "proj/*:env/int:experiment/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:env/dev:holdout/*",
      "proj/*:env/int:holdout/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:layer/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:env/dev:flag/*",
      "proj/*:env/int:flag/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:env/dev:segment/*",
      "proj/*:env/int:segment/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:metric/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }

  policy_statements {
    resources = [
      "proj/*:metric-group/*"
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
      "webhook/*"
    ]
    actions = [
      "*"
    ]
    effect = "allow"
  }
}

resource "launchdarkly_team" "old_mutual_developers" {
  key         = "old-mutual-devs"
  name        = "Old Mutual: Developers"
  description = "Development team"
  custom_role_keys = [
    "old-mutual-devs-example-policy"
  ]

  # ignore changes to team membership to avoid overwriting IDP assignments
  lifecycle {
    ignore_changes = [member_ids]
  }
}