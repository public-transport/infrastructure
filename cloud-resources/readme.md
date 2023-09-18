# Cloud resources

We use [Terraform](https://www.terraform.io/) to manage our cloud infrastructure (things such as servers, S3 buckets, databases, managed kubernetes, etc.), following the concept of *[Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code)*.

Moreover, we use [Terraform Cloud's free tier](https://www.terraform.io/cloud) as the Terraform _backend_. Terraform uses a _backend_ to store and manage its state. One could also use a local file or an S3 bucket to store the state, but [Terraform Cloud](https://www.terraform.io/cloud) has the additional advantage - besides having a free tier - of also including a CI/CD integration for GitHub, meaning that changes will be applied automatically as soon as we merge a PR affecting files in the `/cloud-resources` directory.

## Providers

Most cloud providers have their own terraform plugins, these are usually quite well-documented. Here is a list of providers used by us:

| Provider (country) | Our usage | Docs |
| ------------------ | --------- | -------------- |
| **[Hetzner](https://www.ovh.com/public-cloud)** (:de: Germany) | Kubernetes cluster and workers, via [kube-hetzner ❤️](https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner) | [docs](https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner/blob/master/docs/terraform.md) |
| **[DigitalOcean](https://www.digitalocean.com/)** (:us: U.S.) | Domain(s) | [docs](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs) |
| **[MongoDB Atlas](https://www.mongodb.com/atlas)** (:us: U.S.) | Document database(s) | [docs](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs) |
| **[Better Uptime](https://betteruptime.com)** (:us: U.S.) | Uptime monitoring ([dashboard](https://public-transport.betteruptime.com/)) | [docs](https://registry.terraform.io/providers/BetterStackHQ/better-uptime/latest/docs) |

Furthermore, we make use of the [GitHub](https://registry.terraform.io/providers/integrations/github/latest/docs) and [Flux](https://registry.terraform.io/providers/fluxcd/flux/latest/docs) providers to set up GitHub API tokens and deploy flux to our kubernetes cluster, respectively.

## Other cloud providers not (yet) managed via terraform

Some parts of our setup are not managed via terraform - sometimes because we just didn't have time/ambition to do so just yet, otherwise because some companies don't provide any terraform providers to manage their services.

- [Grafana Cloud](https://grafana.com/products/cloud) - storage and dashboards for logging, metrics, etc.
- [DigitalOcean](https://www.digitalocean.com/) - S3 bucket(s)

## Expenses and donations

Our expenses and donation incomes are documented [here](./expenses/readme.md).
