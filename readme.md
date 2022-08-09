# infrastructure

This repository defines our shared cloud infrastructure as well as the applications running on it. Following the ideas of *[Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code)* and *[GitOps](https://www.redhat.com/en/topics/devops/what-is-gitops)*, all changes to the setup are introduced through pull requests and applied automatically after merging.

## Cloud infrastructure

We use [Terraform](https://www.terraform.io/) to manage our cloud infrastructure (things such as servers, S3 buckets, databases, managed kubernetes, etc.). Check the [docs in `/cloud-resources`](./cloud-resources/) for details.

## Applications

We use [Kubernetes](https://en.wikipedia.org/wiki/Kubernetes) to run most of our applications. Check the docs in [docs in `/kubernetes`](./kubernetes/) for details.

## (How) Can I deploy my apps here?

You're invited to deploy your FOSS apps on our infrastructure, under the preconditions that you commit to our [code of conduct](./code-of-conduct.md) and that your apps' resource requirements aren't too demanding.

Furthermore, hosting someone else's software always mandates a certain level of trust, so these conditions should not be seen as fully exhaustive.

**You can find a step-by-step guide for deploying new apps on our cluster [here](./kubernetes/#how-can-i-deploy-my-own-app), and feel free to ask for help at any time! 🙂**

## Contributing

If you found a bug or want to propose a feature, feel free to visit [the issues page](https://github.com/public-transport/infrastructure/issues).

_Note that, by participating in this project, you commit to the [code of conduct](code-of-conduct.md), and release all contributions under the [ISC license](https://opensource.org/licenses/ISC)._

## Expenses and donations

Our expenses and donation incomes are documented [here](./cloud-resources/expenses/readme.md). Our projects are made possible by these great sponsors 💚:

- [@AghiadHaloul](https://github.com/AghiadHaloul)
- [@Allfein](https://github.com/Allfein)
- [@ajoga](https://github.com/ajoga)
- [@Avanade](https://github.com/Avanade)
- [@colingdc](https://github.com/colingdc)
- [@DerMAp](https://github.com/DerMAp)
- [@dfkbg](https://github.com/dfkbg)
- [@duhovnik](https://github.com/duhovnik)
- [@EmmanuelJacobs](https://github.com/EmmanuelJacobs)
- [@GaiusVampus](https://github.com/GaiusVampus)
- [@ianpherbert](https://github.com/ianpherbert)
- [@katrinleinweber](https://github.com/katrinleinweber)
- [@mlobeck](https://github.com/mlobeck)
- [@nyiri](https://github.com/nyiri)
- [@ondrejsevcik](https://github.com/ondrejsevcik)
- [@sipoh](https://github.com/sipoh)
- [@unflores](https://github.com/unflores)

_If you donated privately, but also want to be listed here, or if you donated publicly, but don't want to be featured, reach out to [@juliuste](https://github.com/juliuste) via [email](mailto:mail@juliustens.eu)._
