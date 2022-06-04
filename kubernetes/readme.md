# Kubernetes

We use [Kubernetes](https://en.wikipedia.org/wiki/Kubernetes) to run our applications. Moreover, we make use of [Flux v2](https://fluxcd.io/), which allows us to manage kubernetes resources as code that is checked into this repository, following the concept of *[GitOps](https://www.redhat.com/en/topics/devops/what-is-gitops)*, but more on that below.

## How does it work?

This repository contains a couple of so-called [_Kustomizations_](https://kustomize.io/) (basically kubernetes `yaml` files on steroids), specifying which kubernetes resources should exist on our cluster.

The aforementioned [Flux v2](https://fluxcd.io/) is an application that is watching this repository and automatically creating, updating and removing kubernetes resources once new commits are added here. Flux is not deployed on an external server, but also running directly on our cluster, and even its own resources are managed through this repository, although  the initial installation of Flux needed to be done manually in the beginning (you need to start somewhere, after all 😅). The [itempotent](https://en.wikipedia.org/wiki/Idempotence) script for doing that initial kick-starting part can be found [here](./bootstrap-flux.sh) (the script also takes care of giving Flux access to read/write this repository).

Flux performs one more crucial task to make this whole setup work: Let's suppose you're working on an app that is deployed here, and you create new releases of your app from time to time. Ideally, you don't want to manually update your app's version tag everytime you build and push a new container image. This is why flux can be told to watch specific images in a docker registry, or specific charts in a helm registry, for updates, and automatically update and commit the latest tag to this repository, even following sophisticated versioning schemes, if you want.

Refer to the [Flux v2 docs](https://fluxcd.io/docs/) for a more detailed overview regarding flux's features.

## How can I deploy my own app?

This guide assumes that you want to deploy a simple app, consisting of one docker container that you want to expose at a (sub-)domain under your control. If you need anything else for your app (e.g. multiple containers, a persisted disk, etc.), or this guide is too hard to follow, feel free to contact [@juliuste](https://github.com/juliuste) directly, or open an issue on [the issues page](https://github.com/public-transport/infrastructure/issues). We're more than happy to help, and don't be discouraged even if you don't understand anything, that happens to a lot of people working with the kubernetes ecosystem for the first time (or even the 100th time 😅), so don't worry.

Ok, now back to the instructions. To deploy your app, you need to do a couple of things in this repository and one thing in your app's repo.

### In your app's repository

In your app's repository, you should set up a CI task to automatically build and publish a docker image containing the latest code to a docker registry of your choice. Before publishing, the built image needs to be tagged as `v1_<first-seven-characters-of-git-commit-hash>_<date-as-YYYY-MM-DDTHH.mm.ssZ`>, so e.g. `v1_abcdef0_2021-10-08T12.44.03Z`. Instead of implementing this yourself, though, you can just refer to our **[`example-deployment`](https://github.com/public-transport/example-deployment)** and copy `.github/workflows/ci.yaml` from there, which publishes to [GitHub's container registry](https://ghcr.io) out of the box, without the need for any configuration. 😎

### In this repository

1. Pick an identifier for your app. Just some string containing only lowercase characters and hyphens (`-`), that makes it clear to other people reading the code what app they're looking at. You will need that identifier in the following steps, we'll just use `some-app` as an example.
2. Go to the `kubernetes/apps` directory and clone the `example-app` folder to a new directory called `some-app` (your identifier).
3. Open the file `release.yaml` in the `some-app` directory you just created. There are a handful of comments beginning with the term `[MODIFY]` in there, indicating fields that you need to modify and explaining what you need to fill them with, go ahead with that.
4. Open the file `kubernetes/apps/kustomization.yaml`, which contains a list of all deployed apps. Add your app's identifier there (e.g. `some-app`) below the `example-app`.
5. If your app needs to use some secret environment variables, … *docs still TBD (for now, contact [@juliuste](https://github.com/juliuste) to help you in this case, we already have a system set up allowing you to upload secrets to git in an encrypted manner, docs will be added here later)*
6. Create a PR with your changes. Your app should be deployed once that PR is merged.
7. Create a `CNAME` record for your domain to `cluster.infra.public-transport.earth`. If you can't use a `CNAME` record, create an `A` record to `51.91.26.140` instead (IPv6 is tbd).

### Updating existing apps

As mentioned before, your app will be updated automatically as long as you publish docker images tagged in the aforementioned format. However, there might be times where you want to change some configuration here first instead of updating automatically. For these situations, the docker tags include versioning information, by default `v1_…`. If you want to introduce a breaking change to your app, you can do so as follows:

- Update your app's repository to tag docker images with `v2_…` instead of `v1_…`
- Make any required changes to the infrastructure defined in this repo
- In your app's `release.yaml`, under the `image` section, add the option `tagUpdatePattern: '^v2_[a-fA-F0-9]{7}_(?P<datetime>.*)Z$'`. This replaces the regex determinining which docker tags your app can be upgraded to, flux will then automatically install the latest image tagged with `v2_…`

### Dislaimer regarding scaling

Some of the most common reasons for using Kubernetes are the fault-tolerance and scalability you can achieve for your deployments. One disclaimer in that regard: By default, apps you add here don't scale automatically. The reason for this is that our infrastructure (meaning the number of worker machines) also doesn't scale up automatically for now, so having apps "autoscale" by default might cause misunderstandings and a false sense of security. However, enabling autostaling can still make sense, even on a finite pool of machines, and is very easy with our setup, only requiring a bit of additional configuration in your app's `release.yaml` (tbd).

## What's the structure of all these configuration files and directories?

You only need to read this if you're interested in doing anything beyond deploying simple apps.

The basic structure of the `kubernetes` directory is as follows:

- `.charts` contains our own custom helm charts, which help us to reduce code and complexity overall. These charts are automatically packaged and published by our CI using GitHub releases and GitHub pages
- `apps` contains all app-specific resources (except secrets)
- `secrets` contains secrets encrypted with the public key in `secrets/.sops.pub.asc`
- `infrastructure` contains underlying components required by most/all apps, such as tls certificate issuing or log collection
- `cluster` is the "entrypoint" for our cluster, all required resources are imported/referenced here from the other directories listed above. Think of everything in `cluster` as the cluster's `package.json`, just split up into different files :smile:

## Still TBD

- Logging (docs missing)
- Metrics
