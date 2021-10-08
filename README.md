<h1 align="center"> ☁️ Hikariai Sites</h1>
<p align="center">
    <em>My main websites built with Hugo, containerized as a microservice</em>
</p>

<p align="center">
    <img src="https://img.shields.io/github/license/yqlbu/hikariai-web?color=critical" alt="License"/>
    <a href="https://hits.seeyoufarm.com">
      <img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fyqlbu%2Fhikariai-web&count_bg=%23D055FF&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/>
    </a>
    <a href="https://img.shields.io/tokei/lines/github/yqlbu/hikariai-web?color=orange">
      <img src="https://img.shields.io/tokei/lines/github/yqlbu/hikariai-web?color=orange" alt="lines">
    </a>
    <a href="https://hub.docker.com/repository/docker/hikariai/">
        <img src="https://img.shields.io/badge/docker-v20.10.7-blue" alt="Version">
    </a>
    <a href="https://github.com/yqlbu/hikariai-web">
        <img src="https://img.shields.io/badge/kubernetes-v1.22-navy.svg" alt="Kubernetes"/>
    </a>
    <a href="https://github.com/yqlbu/hikariai-web">
        <img src="https://img.shields.io/github/last-commit/yqlbu/hikariai-web" alt="lastcommit"/>
    </a>

</p>

## Introduction

[hikariai.net](https://hikariai.net) is a self-hosted site that covers topics ranging from `Cloud Computing`, `Robotics`, `Edge AI`, `IoT`, and more. The main purpose of the site is to document and share practical cases that I dealt with throughout my career as a DevOps Engineer and Cloud Solution Architect. I am also an AI enthusiast who love to explore the latest cutting-edge AI technology and its applications in daily usage.

You may connect me via [link.hikariai.net](https://link.hikariai.net), which is a microservice that I build for sharing.

The site is containerized and automated based on principals followed by `DevOps` and `GitOps` practices with CICD tools such as [Tekton](https://tekton.dev/), [ArgoCD](https://argoproj.github.io/argo-cd/) that fit in the modern `cloud-native` fashion. In terms of deployment, it is orchestrated with `Kubernetes` with proper service discovery routing rules handled by [Istios](https://istio.io/). You may find the `Dockerfile` in the `/ci` directory of this repository.

## Community

- [Hikariai_AI Telegram Group](https://t.me/hikariai_channel)
- [unRAID Telegram Group](https://t.me/unraid_zh)
- [TechProber Telegram Group](https://t.me/joinchat/7AG3aEQ5I00wY2Q5)
- [TechProber Discord Channel](https://discord.gg/se4RtrB473)

## Reference

- [Hugo Offical Site](https://gohugo.io/)
- [Hugo Themes](https://themes.gohugo.io)
- [Liva Theme](https://docs.gethugothemes.com/liva/)

## License

[MIT (C) Kevin Yu](https://github.com/yqlbu/hikariai-web/blob/master/LICENSE)
