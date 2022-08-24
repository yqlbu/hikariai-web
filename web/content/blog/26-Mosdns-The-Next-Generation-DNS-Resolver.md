---
title: "Mosdns - The next generation DNS kesolver"
image: "images/post/post-26.jpg"
socialImage: "/images/post/post-26.jpg"
date: 2022-08-24
author: "Kevin Yu"
tags: ["Networking"]
categories: ["Networking"]
draft: false
---

Recently, I found a very interesting open-source project called mosdns, which is regarded as the _next generation DNS resolver_ from the user's perspective. [Mosdns](https://github.com/IrineSistiana/mosdns) is written in [Golang](https://go.dev/), leveraging its native concurrecny capability, in which it can massively reduce the overheads when it comes to resolve domains in the context of latency and efficiency. In this post, we will unvein the mysterey of DNS Resolver, explore what this project can offer, and make our self-hosted DNS resolver much stronger and more secure.

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

When you use the Internet, every time you connect to a website using its domain name (such as "computerhope.com"), your computer needs to know that website's IP address (a unique series of numbers). So your computer contacts a DNS resolver, and gets the current IP address of computerhope.com.

Usually, the resolver is one part of a larger decentralized DNS (domain name system). When you send your request to the DNS resolver, the resolver accesses other servers in the DNS to obtain the address, then sends you the response.

The DNS resolver contacted by your computer is usually chosen by your ISP (Internet service provider). However, you can configure your network to use a different DNS provider, if you choose. This configuration can be modified in your operating system's network settings, or in the administration interface of your home network router.

### How DNS Resolver works?

DNS resolvers are the clients that query for DNS information from a nameserver. These programs run on a host to query a DNS nameserver, interpret the response, and return the information to the programs that request it. In DNS, the resolver implements the recursive query algorithm that traverses the inverted namespace tree until it finds the result for a query (or an error).

The following diagram from Amazon’s Route 53 documentation gives an overview of how recursive and authoritative DNS services work together to route an end user to your website or application.

![](https://sookocheff.com/post/networking/how-does-dns-work/assets/dns-resolution.png)

To understand more about the DNS workflow, check out the this [blog post](https://sookocheff.com/post/networking/how-does-dns-work/).

### What are DoH and DoT?

The following diagram demonstrates the differences between `http` and `https` when it comes it exchanging data in between client and server

![](https://nrmjjlvckvsb.compat.objectstorage.ap-tokyo-1.oraclecloud.com/picgo/2022/08-24-d58879e667a37bb3368ecd443860c6a6.png)

`DNS-over-HTTPS (DoH)` and `DNS-over-TLS (DoT)` are both trying to solve the problem of hiding the DNS queries. DNS over HTTPS is an internet security protocol that communicates domain name server information in an `encrypted` way over HTTPS connections.

As most organizations are already aware, a DNS traffic filtering solution is crucial for their cybersecurity environment. But while most organizations are already using a DNS traffic filter, the dilemma brought on by DoH is that compatibility issues may arise once browsers start using DoH by default.

Here is what can be problematic. DNS traffic filtering solutions are using the settings built-in Operating Systems to perform DNS queries. However, if the browser is no longer in-use the standard DNS port (53) for queries and instead switch to the DoH one (443), the traffic filtering solution will lose sight of those queries.

While DoH indeed brings more privacy by default, it should not be confused with compliance or security.

To understand more, please check out this [blog post](https://heimdalsecurity.com/blog/dns-over-https-doh/).

---

## Demystify Mosdns

- [IP-based DNS Solution](#ip-based-dns-solution)
- [Region-based DNS Solution](#region-based-dns-solution)
- [Ads-free DNS Solution](#ads-free-dns-solution)
- [Cache Solution](#cache-solution)

### IP-based DNS Solution

### Region-based DNS Solution

### Ads-free DNS Solution

### Cache Solution

---

## Workflow

---

## Configuration

---

## How to deploy

- [Prerequisites](#prerequisites)
- [CLI](#cli)

### Prerequisites

### CLI

---

## Conclusion

---

## Further Readings

---
