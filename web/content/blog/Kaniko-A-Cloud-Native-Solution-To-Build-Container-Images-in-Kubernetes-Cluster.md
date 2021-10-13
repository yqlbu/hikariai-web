---
title: "Kaniko: A Cloud-Native solution to build container images in Kubernetes Cluster"
description: "Build container images in Kubernetes Cluster"
image: "images/post/post-22.jpg"
socialImage: "/images/post/post-22.jpg"
date: 2021-04-06
author: "Kevin Yu"
tags:
  [
    "Cloud",
    "Cloud Computing",
    "Cloud Native",
    "Mircoservices",
    "Kubernetes",
    "Software",
  ]
categories: ["Cloud Computing"]
draft: false
---

Building images from a standard Dockerfile typically relies upon interactive access to a Docker daemon, which requires root access on your machine to run. This can make it difficult to build container images in environments that can’t easily or securely expose their Docker daemons, such as Kubernetes clusters. In addition, Kubernetes is deprecating Docker as a container runtime after version 1.20. Docker as an underlying runtime is being deprecated in favor of runtimes that use the Container Runtime Interface (CRI) created for Kubernetes. Hence, an alternative such as [ Kaniko ](https://github.com/GoogleContainerTools/kaniko) will continue to shine in the future.

**Refrence:**

- [ Kaniko Repo ](https://github.com/GoogleContainerTools/kaniko)
- [ Introducing kaniko: Build container images in Kubernetes and Google Container Builder without privileges ](https://cloud.google.com/blog/products/containers-kubernetes/introducing-kaniko-build-container-images-in-kubernetes-and-google-container-builder-even-without-root-access)

{{< toc >}}

---

### What is Kaniko?

`Kaniko` is a tool to build container images from a Dockerfile, inside a container or Kubernetes cluster. Kaniko doesn’t depend on a Docker daemon and executes each command within a Dockerfile completely in userspace. This enables building container images in environments that can’t easily or securely run a Docker daemon, such as a standard Kubernetes cluster.

Since there’s no dependency on the daemon process, this can be run in any environment where the user doesn’t have root access like a Kubernetes cluster.

Moreover, Kaniko is very often used with [ Tekton ](https://tekton.dev/), a Cloud-Native Solution for automative CI/CD pipelines. Kaniko may serve as one of the steps to handle the container packaging and publish workload. You may learn more about how to create a complete Tekton pipeline in the tutorial [ HERE ](https://octopus.com/blog/introduction-to-tekton-pipelines).

---

### How Kaniko works?

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-22-image1mu2u.max-700x700.png)

Kaniko executes each command within the Dockerfile completely in the userspace using an executor image: gcr.io/kaniko-project/executor which runs inside a container; for instance, a Kubernetes pod. It executes each command inside the Dockerfile in order and takes a snapshot of the file system after each command.

If there are changes to the file system, the executor takes a snapshot of the filesystem change as a “diff” layer and updates the image metadata.

You may learn more about the mechanism from [ HERE ](https://cloud.google.com/blog/products/containers-kubernetes/introducing-kaniko-build-container-images-in-kubernetes-and-google-container-builder-even-without-root-access)

### Why Kaniko?

As explained at the beginning of the post, building container images with Docker might be the best and convenient way. However, there are many drawbacks. Most importantly, it involves `Security Concerns`.

First of all, you cannot run Docker inside a container without configuring the Docker Socket inside the container because the container environment is isolated from the local machine so that the Docker Engine inside the container cannot directly talk to Docker Client locally. Use the following YAML file as an example:

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: docker
spec:
  containers:
    - name: docker
      image: docker
      args: ["sleep", "10000"]
  restartPolicy: Never
```

You will notice that an error will pop up during the build process. That is due to the reason that the docker container in the Kubernetes Cluster is not able to talk to the Docker Client locally via Docker Socket. Now let’s take a look at the modified YAML file with Docker Socket bound to the container:

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: docker
spec:
  containers:
    - name: docker
      image: docker
      args: ["sleep", "10000"]
      volumeMounts:
        - mountPath: /var/run/docker.sock
          name: docker-socket
  restartPolicy: Never
  volumes:
    - name: docker-socket
      hostPath:
        path: /var/run/docker.sock
```

This time, you will observe that the build process runs fine as you build the image locally with Docker Daemon. This time we are not using Docker inside the container instead we are using Docker on the node. However, this approach contains severe Security Concerns!

{{<notice "info">}}
We mounted the socket that means that anybody capable of running containers in our cluster can issue any commands to Docker running on the node. Basically, it would be relatively easily straightforward to take control of the whole cluster, or even easily to take control of a specific node in the cluster wherever that container is running. Therefore, this is a huge security issue.
{{</notice>}}

{{<notice "info">}}
Morever, Docker is not supported anymore in Kubernetes version greater than 1.20 so you cannot have Docker as the default Container Runtime. Therefore, this approach will not work if there is no Docker on the nodes.
{{</notice>}}

Now that we have discussed why building images with Docker might not be a good idea, let us talk about why Kaniko. Straightforwardly, Kaniko does not rely on Docker, and it can still use Dockerfile as a reference to build container images, which significantly reduces learning cost. Moreover, Kaniko runs as a Pod to handle the building workload, once it finishes, it will be terminated and will free all the allocated resources such as CPU and RAM utilization.

---

### Demo

Let’s now start creating the configuration files required for running Kaniko in the Kubernetes cluster.

Step #1: Download the source code from my github [ repo ](https://github.com/yqlbu/kaniko-demo).

Step #2: Create a secret for Remote Container Registry.

We will need to create a secret resource in the cluster for Kaniko to push the image to any Remote Container Registry. The following is a demo with DockerHub as the Remote Container Registry.

```bash
### Export cedentials as environment variables

export REGISTRY_SERVER=https://index.docker.io/v1/
# Replace `[...]` with the registry username
export REGISTRY_USER=[...]
# Replace `[...]` with the registry password
export REGISTRY_PASS=[...]
# Replace `[...]` with the registry email
export REGISTRY_EMAIL=[...]

### Create the secret

kubectl create secret \
    docker-registry regcred \
    --docker-server=$REGISTRY_SERVER \
    --docker-username=$REGISTRY_USER \
    --docker-password=$REGISTRY_PASS \
    --docker-email=$REGISTRY_EMAIL
```

You may find more information about how to create the secret tailed to container registry [ Here ](https://kubernetes.io/docs/concepts/configuration/secret/#docker-config-secrets).

---

Step #3: Prepare the configuration

Now that the secret is created, we may deploy Kaniko.

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: kaniko
  labels:
    app: kaniko-executor
spec:
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      args:
        - --dockerfile=Dockerfile
        - --context=git://github.com/yqlbu/kaniko-demo.git
        - --destination=hikariai/kaniko-demo:1.0.0
      volumeMounts:
        - name: kaniko-secret
          mountPath: /kaniko/.docker
  restartPolicy: Never
  volumes:
    - name: kaniko-secret
      secret:
        secretName: regcred
        items:
          - key: .dockerconfigjson
            path: config.json
```

**Notes:**

- `--dockerfile` is where you specify the Dockerfile path
- `--context` is where you specify the code remote repository
- `--destination` is where you specify the remote image registry

---

### Building Images Using Kaniko

Apply the configuration

```bash
kubectl apply -f kaniko-git.yaml
```

Check out the logs

```bash
# kev @ archlinux in ~/workspace/kaniko-demo on git:master x [14:23:18]
$ kubectl logs kaniko --follow
Enumerating objects: 40, done.
Counting objects: 100% (40/40), done.
Compressing objects: 100% (26/26), done.
Total 40 (delta 19), reused 25 (delta 9), pack-reused 0

INFO[0010] Resolved base name golang:1.15 to dev
INFO[0010] Resolved base name golang:1.15 to build
INFO[0010] Resolved base name alpine to runtime
INFO[0010] Retrieving image manifest golang:1.15
INFO[0010] Retrieving image golang:1.15 from registry index.docker.io
INFO[0015] Retrieving image manifest golang:1.15
INFO[0015] Returning cached image manifest
INFO[0015] Retrieving image manifest alpine
INFO[0015] Retrieving image alpine from registry index.docker.io
INFO[0019] Built cross stage deps: map[1:[/app/app]]
INFO[0019] Retrieving image manifest golang:1.15
INFO[0019] Returning cached image manifest
INFO[0019] Executing 0 build triggers
INFO[0019] Skipping unpacking as no commands require it.
INFO[0019] WORKDIR /workspace
INFO[0019] cmd: workdir
INFO[0019] Changed working directory to /workspace
INFO[0019] No files changed in this command, skipping snapshotting.
INFO[0019] Deleting filesystem...
INFO[0019] Retrieving image manifest golang:1.15
INFO[0019] Returning cached image manifest
INFO[0019] Executing 0 build triggers
INFO[0019] Unpacking rootfs as cmd COPY ./app/* /app/ requires it.
INFO[0044] WORKDIR /app
INFO[0044] cmd: workdir
INFO[0044] Changed working directory to /app
INFO[0044] Creating directory /app
INFO[0044] Taking snapshot of files...
INFO[0044] Resolving srcs [app/*]...
INFO[0044] COPY ./app/* /app/
INFO[0044] Resolving srcs [app/*]...
INFO[0044] Taking snapshot of files...
INFO[0044] RUN go build -o app
INFO[0044] Taking snapshot of full filesystem...
INFO[0047] cmd: /bin/sh
INFO[0047] args: [-c go build -o app]
INFO[0047] Running: [/bin/sh -c go build -o app]
INFO[0048] Taking snapshot of full filesystem...
INFO[0049] Saving file app/app for later use
INFO[0049] Deleting filesystem...
INFO[0049] Retrieving image manifest alpine
INFO[0049] Returning cached image manifest
INFO[0049] Executing 0 build triggers
INFO[0049] Unpacking rootfs as cmd COPY --from=build /app/app / requires it.
INFO[0052] COPY --from=build /app/app /
INFO[0052] Taking snapshot of files...
INFO[0052] CMD ./app
INFO[0052] Pushing image to hikariai/kaniko-demo:1.0.0
INFO[0059] Pushed image to 1 destinations
```

Finally, check if the container image has already been successfully pushed to the remote container registry.

---

### Conclusion

In this post, we have walked through at a basic introduction to `Kaniko`. We’ve seen how it can be used to build an image and also setting up a Kubernetes cluster with the required configuration for Kaniko to run.

To sum up, Kaniko is an open-source tool for building container images from a Dockerfile even without privileged root access. With kaniko, we both build an image from a Dockerfile and push it to a registry. Since it doesn’t require any special privileges or permissions, you can run kaniko in a standard Kubernetes cluster, Google Kubernetes Engine, or in any environment that can’t have access to privileges or a Docker daemon.

---
