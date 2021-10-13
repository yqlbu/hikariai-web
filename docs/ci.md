# CI Configuration Instruction

Prepare CI workflow accessible for `Kubernetes-based` `staging` and `production` environment and local `dev` environment driven by `Docker`

## Branching CI(Continuous Integration)

By default, this repo is manged by two separate fully self-automated pipeline manged by [Tekton CI](https://tekton.dev) running on my `self-hosted` Kubernetes Cluster. Any commit push to a branch separated from the `master` branch will automatically trigger the `staging-pipeline`, which will tag the image with `staging`, and `www-staging`. Once everything is fully tested in the staging namespace(environment), the container image should be recognized as `ready-for-production`. Once the PR is merged to the `master` branch manually (by the repo owner - me), then the `prod-pipeline` will be triggered. It will update the finalized `staging` container to `prod` container and push it to the Container Registries(in my case, I use Docker Hub and GitHub Container Registry to store all the container images).

You may find the integration [HERE](https://github.com/yqlbu/vsphere-hub/tree/master/cicd/tekton-builds/projects/hikariai-web)

![](https://github.com/yqlbu/hikariai-web/blob/master/screenshots/tekton-demo.png?raw=true)

## Continuous Deployment

The releases of this repository are purely in a `container` form that follows the `Cloud-Native Microservices Principal`. The automation is powered by [ArgoCD](https://argo-cd.readthedocs.io/), a cloud-native Continuous Deployment tools that leads the modern `GitOps` fashion.

You may find the integration [HERE](https://github.com/yqlbu/vsphere-hub/tree/master/cicd/hikariai-web)

![](https://github.com/yqlbu/hikariai-web/blob/master/screenshots/argocd-demo.png?raw=true)

## Tagging mechanism

The tagging mechanism will have something to do with the `version-tag` auto-updater, which I have not yet developed. It will be coming up soon.

## Local Development Setup

### Build Image Locally (Test)

```bash
make build ENV=dev
```

### Build Image Locally (Pre-Prod)

```bash
make build-prod
```

### Run Container Locally (Dev)

Run the `dev` container locally

```bash
make local-run
```

### Run Container Locally (Pre-Prod)

Run the ready for production `staging` container locally

```bash
make prod-run
```

### Ready for Deployment

It will push the image with tags `latest`, `stating`, `www-staging` to `Docker Hub` and `GitHub Container Registry`

```bash
make push
```

## Reference

- [Makefile Tutorial](https://makefiletutorial.com/)
