---
title: "CKA, CKAD Prep"
image: "images/post/post-27.jpg"
socialImage: "/images/post/post-27.jpg"
date: 2023-01-01
author: "Kevin Yu"
tags: ["Kubernetes", "CKA", "CKAD", "CloudNative"]
categories: ["DevOps"]
draft: false
---

In the summer of 2022, I decided that it was time to try again to learn a bit about [Kubernetes](http://kubernetes.io/) because it’s something that becomes more and more important in our IT world.

The best way to study something, for me, is to have a clear objective that forces you to constantly work on a specific topic. It is something very difficult nowadays since I already work 8+ hours a day on a computer and my mental resources after work is almost exhausting. However, things do not stop me from there, and I’ve decided to aim at the [CKA (Certified Kubernetes Administrator)](https://www.cncf.io/certification/cka/) certification by The Linux Foundation. Surprisingly, I successfully passed the exam with ONLY one attempt, so I made another decision to get the [CKAD (Certified Kubernetes Administrator)](https://www.cncf.io/certification/ckad/) done by the end of 2022.

Since I had a lot of doubts during my journey, I’d like to share my experience with the CKA and the CKAD certifications, hoping it could help someone else achieve the same result on the first attempt.

---

{{< toc >}}

---

## Online Courses

After a bit of hunting for discounts, I’ve decided to buy the [Kubernetes Certified Administrator (CKA) with Tests](https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/) and the [Kubernetes Certified Application Developer (CKAD) with Tests](https://www.udemy.com/course/certified-kubernetes-application-developer/) from [Mumshad Mannambeth](https://www.udemy.com/user/mumshad-mannambeth/) and [KodeKloud](https://kodekloud.com/) on [Udemy](https://www.udemy.com/).

The course is very well-structured, with practice labs on some real Kubernetes clusters on KodeKloud (they give you free access to those labs on their learning platform), and I went through the course from the beginning to the end doing all the labs while progressing, which is the best way to fix in your mind what you are learning.

---

## Exam Tips

### CKA Tips

Here are some suggestions/tips about how to pass the **_CKA_** on first attempt, based on my own experience:

- \* [Kubernetes Cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) is your friend. You may find something that is useful during your exam.
- \* Follow the `Udemy/KodeKloud course from the beginning to the end`, studying a bit every day and completing all the labs on the KodeKloud platform. I know the videos are long, but trust me you will NOT regret at the end.
- \* Learn how to use [Kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) tool to install/upgrade a Kubernetes Cluster. In the actual exam, there is a related question to ask you to do certain operations with kubeadm on an existing cluster.
- \* Make sure you understand all control-plane components as they are very important parts in the cluster. For instance, you may be asked to do a cluster backup on the exam, so knowing how the ETCD works is a must.
- \* Become very confident with all the section of [kubernetes.io/docs](http://kubernetes.io/docs/) in order to be very fast in finding YAML skeletons of the different kinds of resources, like PersistentVolumes, NetworkPolicies and the other stuff that can not be created with kubectl imperative commands.
- \* Try to master kubectl imperative commands that allow you to create a YAML skeleton for resources like Pods, Deployments, Roles etc via the `--dry-run=client -o yaml` flags. For instance, create a pod with `kubectl run --image=nginx=latest --dry-run=client -o yaml > pod.yaml`.
- \* Learn how to quickly find info about specific sections of YAML files via the `kubectl explain` command, like kubectl explain pod.spec.containers.volumeMounts to know the parameters you can specify for volume mounts within a container.
- \* Understand the relationship between the `kubelet` on every work node and the `api-server` on the control-plane node.
- \* Carefully **read the exam info/requirements** and verify that your computer satisfies the requirements for the PSI browser that must be installed and used to take the proctored CKA exam.
- \* During the exam, **jump over low-score tasks (1–3%)** if you can’t solve them quickly and try to solve the high-score ones. At the end, go over the tasks once again.
- \* **Always copy the names of objects or target files** that are specified in the exam task to avoid typos.

### CKAD Tips

Here are some suggestions/tips about how to pass the **_CKAD_** on first attempt, based on my own experience:

- \* [Kubernetes Cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/) is your friend. You may find something that is useful during your exam.
- \* Learn how to create `ConfigMaps` and `Secrets` using kubectl imperative commands as it will save your quite a lot of time. For sample, create a secret with `kubectl create secret generic my-secret --from-literal=pass=123456`
- \* Try to master kubectl imperative commands that allow you to create a YAML skeleton for resources like Pods, Deployments, Roles etc via the `--dry-run=client -o yaml` flags. For instance, create a pod with `kubectl run --image=nginx=latest --dry-run=client -o yaml > pod.yaml`.
- \* Have some hands-on experience on `Canary Deployment` and `Traffic Splitting` in Kubernetes. There is a good documentation page on [Canary Deployments](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#canary-deployments) where you can start from.
- \* Learn how `Probe` works in Pod level. For instance, you need to know how to configure an `HttpGet` liveness probe in a pod.
- \* Learn how to use `ServiceAccount` in Pod.
- \* Learn how to use configure regular `Job` and `CronJob` in the cluster.
- \* Make sure you know the basics of `vim`. A few tips I would like to share in terms of vim usage. You can enable `linenumbers` by `:set number`. You can turn on the `paste mode` by `:set paste` to fix any paste formatting issue.
- \* Learn how to determine if an API object is `namespaced-scoped` with the `kubectl api-resources --namespaced=true` command.

---

## Time Management

As of today, you get from `2 hours to 2.5 hours` to complete the kubernetes certification exams. The duration of the administrators exam is 2.5 hours and the application developers exam is 2 hours. Now that is not sufficient to complete all the questions, so it is important to manage your time effectively to pass the exams. Some that makes you think a little bit confused, and some that you have no clue about, hopefully not too many of that. And they are not there in any particular order. You may have easy or tough questions in the beginning or towards the end. Now you don't have to get all of it right. You only need to solve enough to gain the minimum required percentage to pass the exam. `So it is very important to attempt all of the questions`. You don't want to get stuck in any of the early tough questions, and not have enough time to attempt the easy ones that come after. You have the option to attempt the questions in any order you like. So you could skip the tough ones and choose to attempt all the easy ones first. Once you are done, if you still have time, you can go back and attempt the ones you skipped.

`DO NOT GET STUCK ON ANY QUESTIONS, EVEN FOR A SIMPLE ONE.` For example you are attempting to solve a question that looks simple. You know what you are doing, so you make an attempt. The first time you try to execute your work, it fails. You read the error message and realize that you had made a mistake, like a typo. So you go back and fix it and run it again. This time you get an error message, but you are not able to make any sense out of it. Even though that was an easy question, and you knew you could do it, if you are not able to make any sense out of the error message, don't spend any more time troubleshooting or debugging that error. Mark that question for review later, skip it and move on to the next. Now, I know that urge to troubleshoot and fix issues. But this is not the time for it. Leave it to the end and do all the troubleshooting you want after you have attempted all the questions. So here is how I would go about it. Start with the first question. If it looks easy, attempt it. Once you solve it, move over to the next. If that looks easy, attempt it. Once that is finished, go over to the next. If that looks hard, and you think you will need to read up on it, mark it down and go over to the next. The next one looks a bit difficult, but you think you can figure it out. So give it a try. First attempt it fails, you know what the issue is so you try to fix it. The second attempt, it fails again and you don't know what the issue is. Don't spend any more time on it, as there are many easy questions waiting ahead. Mark it down, for review later and go over to the next.

`TO BE GOOD WITH YAML.` You must spend enough time practicing your definition files in advance. If, for each question, you are having to go through each line of your YAML file and fix the indentation errors, you are not going to be able to make it through all questions. Your YAML files don't have to look pretty. Because nobody is going to look at them. I am guessing that the work is evaluated automatically, so only the end result is evaluated and not how pretty your YAML files are. So even if your file looks like this one on the right, where as it should have looked like the one on the left, it's still fine as long as the structure of the file is correct. And that you have the right information in the file and are able to create the required kubernetes object using the file. For that you need to get your YAML basics right. If you are a beginner, check out the coding exercises at Kodekloud that helps you practice and get good with YAML.

---

## Exam References

Here are my bookmarks for the exams. You may find them helpful in preparing your exams.

### CKA References

- \* [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network)
- \* [Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/#how-to-implement-the-kubernetes-networking-model)
- \* [Networking and Network Policy](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy)
- \* [Volumes](https://kubernetes.io/docs/concepts/storage/volumes)
- \* [Taints and Toleration](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- \* [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment)
- \* [Backup an ETCD Cluster](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster)
- \* [Kubeadm Upgrade](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/#upgrading-control-plane-nodes)
- \* [Assign Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
- \* [Create static Pods](https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/)
- \* [Configure a Pod to Use a PersistentVolume for Storage](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolume)
- \* [Claims as Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes)
- \* [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- \* [Safely Drain a Node](https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/)
- \* [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/#the-ingress-resource)
- \* [Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)

### CKAD References

- \* [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- \* [Running Automated Tasks with a CronJob](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/)
- \* [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- \* [Canary Deployments](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/#canary-deployments)
- \* [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- \* [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- \* [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- \* [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- \* [Configure Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- \* [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- \* [Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
- \* [Using a Service to Expose Your App](https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/)
- \* [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- \* [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- \* [Service](https://kubernetes.io/docs/concepts/services-networking/service/)
- \* [Resource Quotas](https://kubernetes.io/docs/concepts/policy/resource-quotas/)

---

## Exam Results

I passed my CKA with a score of `95`, and I passed my CKAD with a score of `97`. In general, I would say go with the CKA exam first as it helps you build foundation knowledge on Kubernetes. CKAD is more like an add-on where it helps you build in-depth knowledge in how to manage your application in Kubernetes in an effective way.

![](https://nrmjjlvckvsb.compat.objectstorage.ap-tokyo-1.oraclecloud.com/picgo/2023/01-01-8414fed76185919a7d4706cd8593f8c2.png)

![](https://nrmjjlvckvsb.compat.objectstorage.ap-tokyo-1.oraclecloud.com/picgo/2023/01-01-9557c2f7d62af951c81ae031b7ba9b94.png)

---

## Conclusion

I worked hard to crack both certifications on the first attempt, and I’m happy I was able to complete this personal challenge. I hope that this article can be useful for someone else who also aims at passing the CKA and the CKAD, feel free to connect with me and drop me a PM for any questions. To challenge myself again, passing the CKS has become one of my objectives in 2023. Let see how it goes.

---
