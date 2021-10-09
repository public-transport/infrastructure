# Kubernetes

We use [Kubernetes](https://en.wikipedia.org/wiki/Kubernetes) to run our applications. Moreover, we make use of [Flux v2](https://fluxcd.io/), which allows us to manage kubernetes resources as code that is checked into this repository, following the concept of *[GitOps](https://www.redhat.com/en/topics/devops/what-is-gitops)*, but more on that below.

## How does this work?

This repository contains a couple of [_Kustomizations_](https://kustomize.io/) (basically kubernetes `yaml` files on steroids), specifying which kubernetes resources should exist. Flux is an application running within the cluster, watching this repo and automatically creating, updating and removing resources once the code is being modified. Flux's own resources are also checked in here, meaning that flux will even sync changes to itself. Of course, the initial installation of flux needs to be done manually, the [itempotent](https://en.wikipedia.org/wiki/Idempotence) script for doing that can be found [here](./bootstrap-flux.sh) (the script also takes care of giving flux access to read/write this repository).

This begs one question, though: How do the resource definitions in here get updated once someone pushes a new version of some app in another repository? Does one need to manually update docker image tags or [helm](https://helm.sh/) chart versions everytime? Luckily, that's not the case. Instead, flux can be told to watch specific images in a docker registry, or specific charts in a helm registry, for updates, and automatically update and commit the tag referenced in this repository, even following sophisticated versioning schemes, if you want.

Refer to the [Flux v2 docs](https://fluxcd.io/docs/) for a more detailed overview regarding flux's features.

## How can I deploy my own app?

This guide assumes that you want to deploy a simple app, consisting of one docker container that you want to expose at a (sub-)domain under your control. If you need anything else for your app (e.g. multiple containers, a persisted disk, etc.), or this guide is too hard to follow, feel free to contact [Julius](mailto:juliustens.eu) directly, or open an issue on [the issues page](https://github.com/public-transport/infrastructure/issues). We're more than happy to help, and don't be discouraged even if you don't understand anything, that happens to a lot of people working with the kubernetes ecosystem for the first time (or even the 100th time 😅), so don't worry.

Ok, now back to the instructions. To deploy your app, you need to do eight things in this repository and one thing in your app's repo.

### In this repository

1. Pick an identifier for your app. Just some lowercase, url-safe string that makes it clear to other people reading the code what app they're looking at. You will need that identifier in the following steps, we'll just use `some-app` as an example.
2. Go to the `kubernetes/apps/prod` directory and copy the `example-app` directory to a new directory called `some-app` (your identifier). This folder contains several sub-directories and files, but you only need to modify two of these, as explained in the following steps.
3. Open the file `app/kustomization.yaml` in the `some-app` directory you just created. There are a handful of comments beginning with the term `[MODIFY]` in there, indicating fields that you need to modify and explaining what you need to fill them with, go ahead with that.
4. Open the file `image/kustomization.yaml` in the `some-app` directory you just created. There are a handful of comments beginning with the term `[MODIFY]` in there, indicating fields that you need to modify and explaining what you need to fill them with, go ahead with that.
5. Open the file `kubernetes/apps/prod/kustomization.yaml`, which contains a list of all deployed apps. Add your app's identifier there (e.g. `some-app`) below the `example-app`.
6. If your app needs to use some secret environment variables, … *docs still TBD (for now, contact [Julius](mailto:juliustens.eu) to help you in this case, we already have a system set up allowing you to upload secrets to git in an encrypted manner, docs will be added here later)*
7. Create a PR with your changes. Your app should be deployed once that PR is merged.
8. Create a `CNAME` record for your domain to `prod.infra.public-transport.earth`. If you can't use a `CNAME` record, create an `A` record to `51.91.26.140` instead (IPv6 is tbd).

### In your app's repository

In your app's repository, you should set up a CI task to automatically build and publish a docker image containing the latest code to a docker registry of your choice. Before publishing, the built image needs to be taged as `v1_<first-seven-characters-of-git-commit-hash>_<date-as-YYYY-MM-DDTHH.mm.ssZ`>, so e.g. `v1_abcdef0_2021-10-08T12.44.03Z`. Instead of implementing this yourself, though, you can just refer to our **[`example-deployment`](https://github.com/public-transport/example-deployment)** and copy/adapt the `.github/workflows/ci.yaml` from there.

## Which structure do these resource files follow?

You only need to read this if you're interested in doing anything beyond deploying simple apps.

The basic structure of the `kubernetes` directory is as follows:

- `apps` contains all app-specific resources, so usually things like `deployments`, `ingresses`, `services`, …
  - `base` contains some re-usable components, can be referenced by kustomizations in `app/prod`
  - `prod` contains kustomizations which will be deployed on the prod cluster. You can either build on top of snippets for `app/prod` or create your own resources from scratch.
- `secrets` contains secrets encrypted with the public key in `secrets/.sops.pub.asc`
- `infrastructure` contains underlying components required by most/all apps, such as tls certificate issuing
- `sources` contains all git and helm repositories flux should watch
- `clusters`
  - `prod` is the "entrypoint" for the prod cluster, all other required resources are "imported" here
