---
title: "Containerized Microservices Cloud CI/CD Pipeline Automation with Jenkins, Helm, Keel, and Kubernetes"
image: "images/post/post-21.jpg"
date: 2020-12-30
author: "Kevin Yu"
tags:
  [
    "Cloud",
    "Cloud Computing",
    "Digital Transformation",
    "Cloud Native",
    "Mircoservices",
    "Helm",
    "Jenkins",
    "Keel",
    "Kubernetes",
    "Automation",
    "CICD",
  ]
categories: ["DevOps"]
draft: false
---

Developers do not want to think about infrastructure and why it takes so long to deploy their code to a real testing environment. They just want it up and running!

This article will walk you through how to prepare and configure your environment to achieve a complete automated `CI/CD pipeline` for your `containerized applications` using `Jenkins`, `Helm`, and `Kubernetes`. You will receive tips on how to optimize your pipeline and a working template for customizing your own pipeline.

**Refrence:**

- [ What is CI/CD? Continuous integration and continuous delivery explained ](https://www.infoworld.com/article/3271126/what-is-cicd-continuous-integration-and-continuous-delivery-explained.html)
- [ What Are Containerized Microservices? ](https://blog.dreamfactory.com/what-are-containerized-microservices/)

{{< toc >}}

---

### What is CI/CD ?

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-k8s-and-cicd.png)

`Continuous Integration (CI)` is a coding philosophy and a set of practices that drive development teams to implement small changes and check-in code to version control repositories frequently. Because most modern applications require developing code in different platforms and tools, the team needs a mechanism to integrate and validate its changes.

The technical goal of CI is to establish a consistent and automated way to build, package, and test applications. With consistency in the integration process in place, teams are more likely to commit code changes more frequently, which leads to better collaboration and software quality.

`Continuous Delivery (CD)` picks up where continuous integration ends. CD automates the delivery of applications to selected infrastructure environments. Most teams work with multiple environments other than the production, such as development and testing environments, and CD ensures there is an automated way to push code changes to them.

---

### Why Switching to Containerized Micro-services ?

`Microservices architecture `is a strategy for building applications. It divides what would normally be a monolithic application into a suite of independent, loosely-integrated services – called “microservices.”

#### The Benefits of Microservices

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-microservice-2048x1152.png)

Reduced interdependencies: With reduced interdependency between the functions and services in the app, microservices offer a pluggable architecture. They let you easily add, upgrade, or remove features and functions within an application or IT infrastructure.

Increased stability and system robustness: When each microservice runs autonomously, the failure of one resource is less likely to negatively affect the entire system.

Faster time to market: Developers can focus on building a `Minimum Viable Product (MVP)` while using existing microservices to complete the rest of an application.

More organized development process: Application development teams can divide themselves into small groups that focus on building one microservice. This allows them not to worry about their code conflicting with other parts of the application.

---

#### Containerized Microservices

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-evolution-application-infrastructure.png)

Running microservices in containers with their necessary executables and libraries means that each microservice operates autonomously with reduced interdependency on the others. Moreover, multiple containers can run on a single OS instance, which eliminates licensing costs and reduces system resource burdens.

---

### What to Achieve ?

{{<notice "info">}}
Make sure you read the following carefully since it articulates the purpose of this article and what you can expect from this solution
{{</notice>}}

By setting up a continuous build to produce your container images and orchestration, the DevOps solution increases the speed and reliability of your deployment. From the point when developers commit the latest code to Git Repository, the pipeline will start building the docker image, perform certain tests, push to the Docker Hub Repository. Once the image is pushed to Docker Hub successfully, the Web-hook will trigger and send an API request to the bound sidecar container in the pod deployed by Kubernetes. Kubernetes will perform a rolling update for the latest docker image.

**Notes:** The entire pipeline does not require any human manipulation and can be finished autonomously.

---

### Software Stacks Pipeline

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-ci-cd-jenkins-helm-k8s.png)

Architecting a CI/CD pipeline for container and microservice-based applications

---

### Solution

#### Software Stacks (Prerequisite)

- `*` HA (High Available) [ K3S ](https://k3s.io/) Kubernetes Cluster (A distribution of lightweight Kubernetes)
- `*` [ Docker ](https://www.docker.com/) (A software platform for building applications based on containers)
- `*` [ Gitlab ](https://about.gitlab.com/) (A web-based Git repository that provides free open and private repositories)
- `*` [ Jenkins ](https://www.jenkins.io/) (An open-source automation server that enables developers around the world to reliably build, test, and deploy their software)
- `*` [ Keel ](https://keel.sh/) (Kubernetes Operator to automate Helm, DaemonSet, StatefulSet & Deployment updates)
- `*` [ Helm ](https://helm.sh/) (A package manager for Kubernetes)
- `*` [ WebhookRelay ](https://webhookrelay.com/) (A fast, reliable, and secure tunneling service that allows you to receive webhooks on the containerized environment)

---

Colons can be used to align columns.

|  Software Components   | Recommended Configuration                                                                                                                                                                                                                                                                                                      |
| :--------------------: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|  A Kubernetes Cluster  | Set up a high availability Kubernetes cluster with 5 nodes (2 master nodes and 3 worker nodes). [ K3S ](https://k3s.io/) is highly recommended since it is lightweight. Consider setting up one [ Nginx LoadBalancer ](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) to route traffic (optional) |
|   A Docker Registry    | Consider using [ Docker Hub ](https://hub.docker.com/) as the primary option. Consider a solution such as [ Habor ](https://goharbor.io/) for hosting a private Docker registry (optional)                                                                                                                                     |
|   A Helm Repository    | Find a solution such as [ ChartMuseum ](https://chartmuseum.com/) for hosting a private Helm repository                                                                                                                                                                                                                        |
|    A Git Repository    | Find a solution such as [ GitLab ](https://about.gitlab.com/) for hosting a private Git repository                                                                                                                                                                                                                             |
| A Jenkins Master Node  | Set up the master with a standard [ Jenkins ](https://www.jenkins.io/) configuration. Consider setting up a Jenkins cluster with one master node and two slave nodes, depending on your workload (optional)                                                                                                                    |
| A WebhookRelay Account | Set up an account with [WebhookRelay](https://webhookrelay.com/) to send/receive API requests                                                                                                                                                                                                                                  |

---

#### Setup

{{<notice "info">}}
This article will not focus on setting up the softwares. However, you may use the links below to find the guide to install the required softwares.
{{</notice>}}

- [ Set up a HA K3S Cluster ]()
- [ Set up Kubernetes dashboard ]()
- [ Create a base Docker image ]()
- [ Set up GitLab ]()
- [ Set up Jenkins ]()
- [ Set up a Webhook with GitLab and Jenkins (Any new commits to GitLab with trigger a Jenkins build) ]()
- [ Build and Push Docker image with Jenkins docker plugins ]()
- [ Set up Helm ]()
- [ Set up ChartMuseum (Private Helm Repository) ]()
- [ Set up Keel (Kubernetes Operator to automate Helm) ]()
- [ Deploy WebhookRelay agent container (Sidecar Container) ]()
- [ Trigger Keel with WebhookRelay (Sidecar Container Method) ]()

---

#### Solution Guidelines

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-feature-image.jpg)

Now that everything is set up and up to date, we may now talk about the workflow of this CI/CD solution for Containerized Microservices. Follow these guidelines below when preparing your applications:

{{<notice "note">}}
GitLab, Helm, and Jenkins can be deployed in the same node server or VM (Recommended)
{{</notice>}}

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screenshot%202021-10-10%20at%206.08.44%20PM.png)

---

### Progress

[#1] Push Code from Git

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-5.56.23-PM-2048x1000.png)

---

[#2] Run Builds and Unit tests on Jenkins

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-5.56.41-PM-2048x697.png)

---

[#3] Publish Docker Image and Helm Chart with Jenkins

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-5.56.59-PM-2048x956.png)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-6.01.36-PM-2048x836.png)

---

[#4] Deploy to Development on Kubernetes Cluster

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-6.04.28-PM-2048x866.png)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-6.22.02-PM-2048x873.png)

---

[#5] Perform Rolling Updates on Kubernetes

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-5.59.07-PM-2048x996.png)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-5.57.29-PM-2048x945.png)

![](https://objectstorage.ap-tokyo-1.oraclecloud.com/n/nrmjjlvckvsb/b/blog-content-20211009/o/post-21-Screen-Shot-2020-12-30-at-5.58.31-PM-2048x871.png)

CI/CD Pipeline completed.

---

### Conclusion

#### CI/CD Pipeline

From the experiment above, we may see that the latest version of the application docker image has been built, pushed, and deployed to our Kubernetes cluster successfully. The DevOps solution massively increases the speed and reliability of your deployment.

#### Containerized Microservices

In my experience, using a container orchestration platform is a `must` in building your application with microservices. Kubernetes is one of the popular choices by developers as it quickly brings their application from development to production. And, even better, it’s open-source!

For developers who are starting to build their applications, they should decide whether it would be beneficial to them to use a `microservices` architecture rather than a monolithic one. They should consider the `long-term usability and scalability` of their application. It’s okay to start with a monolithic architecture, but once the application grows in size, it would only get harder to decompose them into microservices. In that case, it would be more beneficial to start off with microservices in the early development phase. For existing monolithic applications, developers should consider how and which components they would decouple in their application.

---
