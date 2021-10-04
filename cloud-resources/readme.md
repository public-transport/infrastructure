# Cloud resources

This part of our setup contains the base infrastructure layer on which applications can be deployed. We're talking things like S3 buckets, kubernetes clusters and nodes, databases or plain compute instances. We use [Terraform](https://www.terraform.io/) to manage these resources, and [Terraform Cloud's free tier](https://www.terraform.io/cloud) as the Terraform backend, which includes an automatic CI/CD integration for this repository, so that things will get deployed as soon as we merge a PR affecting files in the `/cloud-resources` directory.
