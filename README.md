> ! TAKE NOTE! Running terraform apply on any of these directories with your auth credentials will result in real resources being created that may cost real money. These are meant to be used as examples only and LaunchDarkly is not responsible for any costs incurred via testing.

# Setup

## Install Terraform

First and foremost, you need to make sure you have Terraform installed on the machine you will be applying the configurations from and that you meet the requirements listed on the [project readme](https://github.com/hashicorp/terraform-provider-launchdarkly#requirements). For instructions on how to install Terraform, see [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

## Configure LD Credentials

Before getting started with the LaunchDarkly provider, you need to ensure you have your LaunchDarkly credentials properly set up. All you will need for this is a LaunchDarkly access token, which you can create via the LaunchDarkly platform under Account settings > Authorization. You will need a token that has sufficient authorization to create/update/delete the resources that will be managed by the provider. I recommend using a [service access token](https://docs.launchdarkly.com/home/account/api#service-tokens) for the integration.

Once you have your access token in hand, set the terraform variable `launchdarkly_access_token`. One way to do this is by creating a `terraform.tfvars` file with the following content:

```terraform
launchdarkly_access_token="my-api-key-here"
```

For other methods, refer to the [terraform documentation](https://developer.hashicorp.com/terraform/language/values/variables)