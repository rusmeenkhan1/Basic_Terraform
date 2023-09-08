# this configuration is needed because when we don't specify any provider it will look into
# hashicorp repository . We have to explicitly define source for unofficial providers.

#for aws it is okay to ignore this file as it is
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.15.0"
    }
  }
}