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

## Demystify Mosdns

- [Plugins](#plugins)
- [IP-based DNS Solution](#ip-based-dns-solution)
- [Region-based DNS Solution](#region-based-dns-solution)
- [Ads-free DNS Solution](#ads-free-dns-solution)
- [Cache Solution](#cache-solution)

> Mosdns is a plugin-based DNS forwarder. Users can splice plugins as needed and customize their DNS processing logic.

### Plugins

<details><summary> -- QueryMatchers -- </summary>

- `query_matcher`: Matching query characteristics. e.g Domain name, type, source IP, etc.
- `response_matcher`: Matching query characteristics. e.g. response IP, CNAME, etc.

</details>

</br>

<details><summary> -- Common -- </summary>

- `forward`: Forward the request to the upstream DNS.
- `cache`: Store response in the cache. Support using `redis` as external cache storage
- `_prefer_ipv4/6`: Automatically determine whether the domain name is a dual-stack domain name and then shield the IPv4/6 request which will not affect the pure IPv6/4 domain name.
- `ecs`: Attach ECS to request
- `hosts`: Set specific IP to the target domain
- `blackhole`: Drop the request, form an empty response, or generate a response with specific IPs. Commonly used in shielding responses.
- `ttl`: Overwrite default TTL
- `redirect`: Replace (redirect) the requested domain name. Request domain names A, but return the record of domain name B.
- `padding`: Fill encrypted DNS messages to a fixed length to prevent traffic analysis.
- `bufsize`: UDP fragmentation prevention
- `arbitrary`: For advanced users. You may manually build an answer that contains any records.
- `reverse_lookup`: API usage. The domain name processed by mosdns can be traced by IP.

</details>

</br>

<details><summary> -- Dynamic Routing -- </summary>

- `ipset`: Write response IP to ipset.
- `nfset`: Write response IP to nftables.

</details>

### IP-based DNS Solution

Mosnds is compatible with [v2ray-rules-dat](https://github.com/Loyalsoldier/v2ray-rules-dat), which we can use easily to achieve `IP-based DNS` by including the `geoip.dat` in the mosdns configuration. The `query_matcher` is capable of filtering out `IPs` which are based on a particular region so that we can reference the `tag` when executing a query search.

Example:

```yaml
# config.yml

# data source config
data_providers:
  - tag: geoip
    file: "/etc/mosdns/geoip.dat"
    auto_reload: false

plugins:
  # --- query matcher ---
  # query - CN IP
  - tag: response_cnip
    type: response_matcher
    args:
      ip:
        - "provider:geoip:cn"
```

### Region-based DNS Solution

Same as `geoip.dat`, `geosite.dat` can be downloaded from [v2ray-rules-dat](https://github.com/Loyalsoldier/v2ray-rules-dat). The `query_matcher` is capable of filtering out `domains` which are based on a particular region so that we can reference the `tag` when executing a query search.

```yaml
# config.yml

# data source config
data_providers:
  - tag: geoip
    file: "/etc/mosdns/geosite.dat"
    auto_reload: false

plugins:
  # --- query matcher ---
  # query - CN domains
  - tag: query_cn
    type: query_matcher
    args:
      domain:
        - "provider:geosite:cn"

  # query - non-CN domains
  - tag: query_notcn
    type: query_matcher
    args:
      domain:
        - "provider:geosite:geolocation-!cn"
```

### Ads-free DNS Solution

For queries that are categorized as `ads`, they can be picked up by the `query_matcher` as the following:

```yaml
# config.yml

# data source config
data_providers:
  - tag: geoip
    file: "/etc/mosdns/geosite.dat"
    auto_reload: false

plugins:
  # --- query matcher ---
  # query - ad
  - tag: query_ad
    type: query_matcher
    args:
      domain:
        - "provider:geosite:category-ads-all"
```

### Cache Solution

Mosdns offers two ways of handling `cache`: `in_memory` cache and `external cache`

#### In-memory Cache

As its name suggests, the plugin can save query responses to local memory.

```yaml
# config.yml

plugins:
  # --- Excutable Plugins --- #
  cache
  - tag: "mem_cache"
    type: "cache"
    args:
      size: 1024 # query max number
      lazy_cache_ttl: 86400 # lazy cache ttl
      lazy_cache_reply_ttl: 30 # timeout ttl
      cache_everything: true
```

#### External Cache

Another way to leverage the caching capability is to set up an external cache. Mosdns supports using [Redis](https://redis.io/) as the external storage. Query response can be saved to the target table defined in `config.yml`

```yaml
# config.yml

plugins:
  # --- Excutable Plugins --- #
  - tag: "redis_cache"
    type: "cache"
    args:
      size: 1024 # query max number
      lazy_cache_ttl: 86400 # lazy cache ttl
      lazy_cache_reply_ttl: 30 # timeout ttl
      cache_everything: true
      # redis config
      redis: "redis://<REDIS_SERVER_IP>:<REDIS_PORT>/<DB_ID>" # e.g. redis://10.189.17.4:6379/1
      redis_timeout: 50
```

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
systemctl reload-or-restart systemd-resolved
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

### Redis (Recommended)

Create dirs for redis

```bash
mkdir -p /etc/redis
mkdir -p /etc/redis/redis-conf
mkdir -p /etc/redis/redis-data
```

Redis can be deployed using [Docker-Compose](https://docs.docker.com/compose/)

```yaml
cat > /etc/redis/docker-compose.yml <<EOF
---
version: "3.4"
services:
  redis:
    container_name: redis
    image: "redis:alpine"
    ports:
      - "6379:6379"
    volumes:
      - /etc/redis/redis-data:/data
      - /etc/redis/redis-conf:/etc/redis
    environment:
      - REDIS_REPLICATION_MODE=master
    networks:
      node_net:
        ipv4_address: 172.28.1.4
    command: redis-server /etc/redis/redis.conf
    restart: unless-stopped

  watchtower:
    container_name: watchtower
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    command: ["--cleanup", "--interval", "3600", "--debug"]

# networking for the Redis container
networks:
  node_net:
    ipam:
      driver: default
      config:
        - subnet: 172.28.0.0/16
EOF
```

Copy the following content to `/etc/redis/redis-conf/redis.conf`

```yaml
cat > /etc/redis/redis-conf/redis.conf <<EOF
# admin
# =====
# requirepass ""

# server
# ======
bind 0.0.0.0

# rdb
# ===

# Enable snapshot backups when performing 1 write command in 900 seconds.
save 900 1
# Enable snapshot backup when performing 10 write commands in 300 seconds.
save 300 10
# Enable snapshot backups when performing 10,000 write commands within 60 seconds.
save 60 10000
# Turn on data compression
rdbcompression yes
# Turn on checksum check
rdbchecksum yes
# Specify local database file name
dbfilename dump.rdb

# aof
# ===

# Redis is closed by default, turning on the NO to Yes
appendonly yes
# Specify the local database file name, the default is appendonly.aof
appendfilename "appendonly.aof"
# Specify update log conditions
appendfsync everysec
EOF
```

Spin up the redis server

```bash
# spin up the container instance
docker-compose up -d
# intereact with redis
docker exec -it redis redis-cli
```

Some useful Redis commands

```bash
# intereact with redis
redis-cli
# select target db
127.0.0.1:6379> select <db_number>
# fetch all keys
127.0.0.1:6379> keys *
```

---

## Configuration

- [Configuration Prerequisites](#configuration-prerequisites)
- [Rules and Standards](#rules-and-standards)
- [Sample Configuration](#sample-configuration)

> Mosdns uses standard `YAML` file for advanced configuration. Once the configuration is updated, then you will need to manually restart the mosdns daemon service so that the new configuration can take effect accordingly.

### Configuration Prerequisites

- [DAT Files](#dat-files)

> There is a sample config.yml file available in the [sample Configuration](#sample-configuration) section below

#### DAT Files

Prior to deploying mosdns, head over to [Loyalsoldier/v2ray-rules-dat/releases](https://github.com/Loyalsoldier/v2ray-rules-dat/releases) to download the `geoip.dat` and `geosite.dat` files.

### Rules and Standards

- [Log](#log)
- [Data Providers](#data-providers)
- [API](#api)
- [Servers](#servers)
- [Plugins](#plugins)

> The `config.yaml` file is made up of 5 parts, _log_, _data_providers_, _api_, _servers_, and _plugins_.

#### Log

The `log` block defines the log settings. It is recommended to save logs in `/var/log/mosdns.log`

```yaml
# log config
log:
  level: info # ["debug", "info", "warn", and "error"], default is set to "info"
  file: "/var/log/mosdns.log"
```

You may constantly check the logs with the following command:

```bash
tail -f /var/log/mosdns.log
```

#### Data Providers

The `data_providers` block defines the data sources in which you would like to reference in the other blocks.

```yaml
# data source config
data_providers:
  - tag: geoip
    file: "/etc/mosdns/geoip.dat"
    auto_reload: false
  - tag: geosite
    file: "/etc/mosdns/geosite.dat"
    auto_reload: false
```

#### API

The `api` block defines the API entry. Yet, it is still underdeveloped at the time of writing.

```yaml
# api config
api:
  http: ":8080"
```

#### Servers

The `server` block defines the general server settings.

```yaml
# server config
servers:
  # main query sequence
  - exec: sequence_exec # <- this is the plugin tag that the program will load in the first place
    timeout: 5
    listeners:
      # --- local port binding --- #
      # local ipv6
      - protocol: udp
        addr: "[::1]:53"
      - protocol: tcp
        addr: "[::1]:53"
      # local ipv4
      - protocol: udp
        addr: "127.0.0.1:53"
      - protocol: tcp
        addr: "127.0.0.1:53"

      # --- interface binding --- #
      # lan group <- default interface
      - protocol: udp
        addr: "192.168.1.x:53" # <- change the ip to fit your need
      - protocol: tcp
        addr: "10.178.0.3:53" # <- same as above
      # vlan 17 <- this block is ONLY needed if you have more than one interface
      - protocol: udp
        addr: "10.189.17.3:53"
      - protocol: tcp
        addr: "10.189.17.3:53"
```

#### Plugins

The `plugins` block defines the plugins with dedicated tags, and tags can NOT have the same name.

To learn about the list of available plugins and usage, please check out the [official wiki page](https://irine-sistiana.gitbook.io/mosdns-wiki/mosdns/cha-jian-ji-qi-can-shu)

After receiving the request from the client, the server packages the request data and some client information, constructs a "request context", and passes it to the plugins for further processing. Plugins will be executed in the desired order as defined in the configuration file. After plugins finish their execution cycle, the server returns the response in the "request context" to the client.

```yaml
# plugin config
plugins:
  - tag: "redis_cache"
    type: "cache"
    args:
      size: 2048 # query max number
      lazy_cache_ttl: 86400 # lazy cache ttl
      lazy_cache_reply_ttl: 30 # timeout ttl
      cache_everything: true
      # redis config
      redis: "redis://10.189.17.4:6379/1" # <- redis://<host>:<port>/<db_number>
      redis_timeout: 50

  # ... other plugins goes here

  # main_sequence
  - tag: main_sequence
    type: sequence
    args:
      exec:
        # CN domains
        - if: "query_cn"
          exec:
            - _prefer_ipv4 # ipv4 as priority
            - _pad_query
            - local # local ip as result
            - if: "response_cnip" # cnip as result
              exec:
                - _return # end

        # non-CN domains
        - if: query_notcn
          exec:
            - _prefer_ipv4 # ipv4 as priority
            - _pad_query
            - remote # uncontaminated ip
            - if: "!response_cnip" # non-CN ip as result
              exec:
                - _return # end

        # other condition
        - primary:
            - _prefer_ipv4
            - _pad_query
            - remote
          secondary:
            - _prefer_ipv4
            - _pad_query
            - local
          fast_fallback: 400
          always_standby: true

  # --- sequence execution --- #
  - tag: sequence_exec
    type: sequence
    args:
      exec:
        - _prefer_ipv4
        - if: query_ad # ad
          exec:
            - _new_nxdomain_response # empty response
            - _return
        - redis_cache # cache
        - main_sequence # run main query sequence
        - modify_ttl
```

### Sample Configuration

Sample [config.yml](https://github.com/TechProber/mosdns-lxc-deploy/blob/master/mosdns/config.yml) is available in [TechProber/mosdns-lxc-deploy](https://github.com/TechProber/mosdns-lxc-deploy/).

---

## Conclusion

To sum up, Mosdns is a `plugin-based` DNS forwarder. Users can splice plugins as needed and customize their DNS processing logic. With mosdns, we may get a better DNS processing experience without worrying too much about DNS contamination from the local ISP.

---
