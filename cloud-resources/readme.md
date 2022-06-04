# Cloud resources

We use [Terraform](https://www.terraform.io/) to manage our cloud infrastructure (things such as servers, S3 buckets, databases, managed kubernetes, etc.), following the concept of *[Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code)*.

Moreover, we use [Terraform Cloud's free tier](https://www.terraform.io/cloud) as the Terraform _backend_. Terraform uses a _backend_ to store and manage its state. One could also use a local file or an S3 bucket to store the state, but [Terraform Cloud](https://www.terraform.io/cloud) has the additional advantage - besides having a free tier - of also including a CI/CD integration for GitHub, meaning that changes will be applied automatically as soon as we merge a PR affecting files in the `/cloud-resources` directory.

## Providers

Most cloud providers have their own terraform plugins, these are usually quite well-documented. Here is a list of providers used by us:

| Provider (country) | Our usage | Terraform docs |
| ------------------ | --------- | -------------- |
| **[OVH](https://www.ovh.com/public-cloud)** (:fr: France) | Kubernetes cluster and workers | [docs](https://registry.terraform.io/providers/ovh/ovh/latest/docs) |
| **[DigitalOcean](https://www.digitalocean.com/)** (:us: U.S.) | Domain(s) | [docs](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs) |
| **[Scaleway](https://www.scaleway.com/elements/)** (:fr: France) | Relational database(s) | [docs](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs) |
| **[MongoDB Atlas](https://www.mongodb.com/atlas)** (:us: U.S.) | Document database(s) | [docs](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs) |

## Other cloud providers not (yet) managed via terraform

Some parts of our setup are not managed via terraform - sometimes because we just didn't have time/ambition to do so just yet, otherwise because some companies don't provide any terraform providers to manage their services.

- [UptimeRobot](https://uptimerobot.com/) - uptime monitoring
- [Grafana Cloud](https://grafana.com/products/cloud) - storage and dashboards for logging, metrics, etc.

## Expenses and donations

Our expenses and donation incomes are documented [here](./expenses/readme.md).
