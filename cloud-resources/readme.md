# Cloud resources

We use [Terraform](https://www.terraform.io/) to manage our cloud infrastructure (things such as servers, S3 buckets, databases, etc.), following the concept of *[Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code)*.

Moreover, we use [Terraform Cloud's free tier](https://www.terraform.io/cloud) as the Terraform _backend_. Terraform uses a _backend_ to store and manage its state. One could also use a local file or an S3 bucket for this, but [Terraform Cloud](https://www.terraform.io/cloud) has the additional advantage of also including a CI/CD integration for GitHub, meaning that changes will be applied automatically as soon as we merge a PR affecting files in the `/cloud-resources` directory.

## Providers

We use not only one, but multiple cloud providers for our infrastructure. Most cloud providers have their own terraform plugins, these are usually quite well-documented. Here is a list of providers and their terraform documentations:

| Provider (country) | Our usage | Terraform docs |
| ------------------ | --------- | -------------- |
| **[OVH](https://www.ovh.com/public-cloud)** (:fr: France) | Kubernetes cluster and workers | [docs](https://registry.terraform.io/providers/ovh/ovh/latest/docs) |
| **[DigitalOcean](https://www.digitalocean.com/)** (:us: U.S.) | Domain(s) | [docs](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs) |
