---
title: "Mosdns - The next generation DNS Resolver"
image: "images/post/post-26.jpg"
socialImage: "/images/post/post-26.jpg"
date: 2022-08-24
author: "Kevin Yu"
tags: ["Networking", "DNS", "OSS"]
categories: ["Networking"]
draft: false
---

Recently, I found a very interesting open-source project called mosdns, which is regarded as the _next-generation DNS resolver_ from the user's perspective. [Mosdns](https://github.com/IrineSistiana/mosdns) is written in [Golang](https://go.dev/), leveraging its native concurrency capability, in which it can massively reduce the overheads when it comes to resolving domains in the context of latency and efficiency. In this post, we will unveil the mystery of DNS Resolver, explore what this project can offer, and make our self-hosted DNS resolver much stronger and more secure.

For more details, please check out their [GitHub Repository](https://github.com/IrineSistiana/mosdns)

{{< notice "note" >}}
Yet, at the time of writing, unfortunately, the wiki is ONLY written in Chinese. I've already raised a feature request to the owners and would like to contribute a well-written wiki in English.
{{< /notice >}}

---

## References

- [Blog Post - jargon/dns-resolver](https://www.computerhope.com/jargon/d/dns-resolver.htm)
- [Blog Post - sookocheff/how-does-dns-work](https://sookocheff.com/post/networking/how-does-dns-work/)
- [Blog Post - heimdalsecurity/dns-over-https-explained](https://heimdalsecurity.com/blog/dns-over-https-doh/)

---

## Related Projects

- [GitHub - mosdns](https://github.com/IrineSistiana/mosdns)
- [GitHub - v2ray-rules-dat](https://github.com/Loyalsoldier/v2ray-rules-dat)
- [GitHub - geoip](https://github.com/Loyalsoldier/geoip)
- [GitHub - proxmox-helper](https://github.com/tteck/Proxmox)

{{< toc >}}

---

## Background of DNS

- [What is a DNS Resolver?](#what-is-a-dns-resolver)
- [How DNS Resolver works?](#how-dns-resolver-works)
- [What are DoH and DoT?](#what-are-doh-and-dot)

### What is a DNS Resolver?

A DNS resolver, also known as a resolver, is a server on the Internet that converts domain names into IP addresses.

When you use the Internet, every time you connect to a website using its domain name (such as "computerhope.com"), your computer needs to know that website's IP address (a unique series of numbers). So your computer contacts a DNS resolver and gets the current IP address of computerhope.com.

Usually, the resolver is one part of a larger decentralized DNS (domain name system). When you send your request to the DNS resolver, the resolver accesses other servers in the DNS to obtain the address, then sends you the response.

The DNS resolver contacted by your computer is usually chosen by your ISP (Internet service provider). However, you can configure your network to use a different DNS provider, if you choose. This configuration can be modified in your operating system's network settings, or in the administration interface of your home network router.

### How DNS Resolver works?

DNS resolvers are the clients that query for DNS information from a nameserver. These programs run on a host to query a DNS nameserver, interpret the response, and return the information to the programs that request it. In DNS, the resolver implements the recursive query algorithm that traverses the inverted namespace tree until it finds the result for a query (or an error).

The following diagram from Amazon’s Route 53 documentation gives an overview of how recursive and authoritative DNS services work together to route an end user to your website or application.

![](https://sookocheff.com/post/networking/how-does-dns-work/assets/dns-resolution.png)

To understand more about the DNS workflow, check out this [blog post](https://sookocheff.com/post/networking/how-does-dns-work/).

### What are DoH and DoT?

The following diagram demonstrates the differences between `http` and `https` when it comes it exchanging data between client and server

![](https://nrmjjlvckvsb.compat.objectstorage.ap-tokyo-1.oraclecloud.com/picgo/2022/08-24-d58879e667a37bb3368ecd443860c6a6.png)

`DNS-over-HTTPS (DoH)` and `DNS-over-TLS (DoT)` are both trying to solve the problem of hiding the DNS queries. DNS over HTTPS is an internet security protocol that communicates domain name server information in an `encrypted` way over HTTPS connections.

As most organizations are already aware, a DNS traffic filtering solution is crucial for their cybersecurity environment. But while most organizations are already using a DNS traffic filter, the dilemma brought on by DoH is that compatibility issues may arise once browsers start using DoH by default.

Here is what can be problematic. DNS traffic filtering solutions are using the settings of built-in Operating Systems to perform DNS queries. However, if the browser is no longer in use of the standard DNS port (53) for queries and instead switches to the DoH one (443), the traffic filtering solution will lose sight of those queries.

While DoH indeed brings more privacy by default, it should not be confused with compliance or security.

To understand more, please check out this [blog post](https://heimdalsecurity.com/blog/dns-over-https-doh/).

---

## Workflow

The flowchart below demonstrates the Mosdns workflow in a common use case.

![](https://nrmjjlvckvsb.compat.objectstorage.ap-tokyo-1.oraclecloud.com/picgo/2022/08-25-dc5a235b53ae33d3131083bae573b6be.png)

---

## How to deploy

- [Deploy Prerequisites](#deploy-prerequisites-optional)
- [Releases](#releases)
- [Environment Preparation](#environment-preparation)
- [Reset Port 53](#reset-port-53)
- [CLI](#cli)
- [Redis](#redis)

### Deploy Prerequisites (Optional)

- [Proxmox LXC](#proxmox-lxc)

#### Proxmox LXC

I found out the earist way to get `mosdns` deployed is to deploy it as a `Proxmox LXC Container`. There is an automation script that you can leverage to spin up an LXC Container on Proxmox in minutes.

GitHub Repository - [tteck/Proxmox](https://github.com/tteck/Proxmox)

```bash
# provision Ubuntu LXC
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/ubuntu-v4.sh)"
```

If you also need external cache storage, I would recommend you use the above script to provision two LXC containers, one for `mosdns`, and the other one for `redis`.

![](https://nrmjjlvckvsb.compat.objectstorage.ap-tokyo-1.oraclecloud.com/picgo/2022/08-25-af0e1dec6ad266f3cde3e847ab03843c.png)

### Releases

As suggested by the mosdns maintainers, mosdns is ONLY made up of a single `executable binary` file. Therefore, we can just simply head over to the [release page](https://github.com/IrineSistiana/mosdns/releases), download the executable binary that is compatable with the platform of choice.

{{< notice "note" >}}

For those who host a dedicated `Proxmox` server, and followed the above step to provision LXC containers, you may download the `mosdns-linux-amd64.zip` from the [release page](https://github.com/IrineSistiana/mosdns/releases)

{{< /notice >}}

### Environment Preparation

Get the following steps done so that `mosdns` can be called as `/usr/bin/mosdns`.

```bash
# acquired root access
sudo -i

# install vim and unzip
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install vim unzip -y

# create default mosdns directory
mkdir -p /etc/mosdns

# unzip the release binary
cd /etc/mosdns
unzip mosdns-linux-amd64.zip

# mv the executable binary to /usr/bin
chmod +x mosdns
mv mosdns /usr/bin/
```

### Reset Port 53

By default, `mosdns` runs on port `5533`. If you want to set bind it to port `53`, the default port for DNS, do the following:

Deactivate `DNSStubListener` and update DNS server address. Create a new file: /etc/systemd/resolved.conf.d/mosdns.conf (create a /etc/systemd/resolved.conf.d directory if necessary) with the following contents:

```bash
mkdir -p /etc/systemd/resolved.conf.d

# /etc/systemd/resolved.conf.d/mosdns.conf
[Resolve]
DNS=127.0.0.1
DNSStubListener=no
```

Specifying `127.0.0.1` as DNS server address is necessary because otherwise the nameserver will be `127.0.0.53` which doesn't work without DNSStubListener.

Activate another resolv.conf file:

```bash
sudo mv /etc/resolv.conf /etc/resolv.conf.backup
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

Restart DNSStubListener:

```bash
systemctl daemon-reload
systemctl restart systemd-resolved
```

Verify port open status:

```bash
ss -tupln
```

{{< notice "note" >}}

if everything goes well, you will not see port `:53` from the console outputs.

{{< /notice >}}

### CLI

- [Spin up mosdns](#spin-up-mosdns)
- [Helper](#helper)
- [Install as a daemon service](#install-as-a-daemon-service)

#### Spin up mosdns

```bash
# start mosdns
mosdns start -c /etc/mosdns/config.yaml -d /etc/mosdns
```

#### Helper

```bash
mosdns -h
```

#### Install as a daemon service

> `Mosdns service` is a simple system service management tool. Mosdns can be installed as a `system service` to realize self-starting. Administrator or root privileges are required. Theoretically, it can be used on Windows XP+,Linux/(systemd | upstart | sysv), and OSX/Launchd platforms. Windows, Ubuntu, Debian are available.

```bash
# install mosdns as a daemon service
# mosdns service install -d <mosdns_work_dir> -c <mosdns_config_absolute_path>
mosdns service install -d /etc/mosdns -c /etc/mosdns/config.yaml
# start the service (service will not be automatically start at the first time)
systemctl enable mosdns --now
mosdns service start

# check service status
systemctl status mosdns

# uninstall
mosdns service stop
mosdns service uninstall
```

{{< notice "note" >}}

If you make any changes in the `config.yml` file, please restart the daemon service accordingly.

{{< /notice >}}

---

### Sample Configuration

Sample [config.yml](https://github.com/techprober/mosdns-lxc-deploy/blob/master/mosdns/config-v5.yml) is available in [TechProber/mosdns-lxc-deploy](https://github.com/TechProber/mosdns-lxc-deploy/).

---

## Conclusion

To sum up, Mosdns is a `plugin-based` DNS forwarder. Users can splice plugins as needed and customize their DNS processing logic. With mosdns, we may get a better DNS processing experience without worrying too much about DNS contamination from the local ISP.

---
