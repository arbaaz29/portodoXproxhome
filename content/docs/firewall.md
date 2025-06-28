---
title: Firewall
weight: 4
---

Let's set up the firewall for WAN, DMZ, and LAN so the instances can operate smoothly and securely.

### Objective

- `Allow` traffic to `DMZ` from `WAN`

- `Disable` NAT between `LAN` and `DMZ` 

- `Allow` traffic to and from `Nginx-Reverse-Proxy` to `Guacamole Server`

- `Limit` the traffic only to port `80` and `443`

### NAT

NAT (Network Address Translation) helps secure private instances from the public internet by acting as a forward proxy. When a private instance sends a request to the internet, the request originally includes the instance's private IP address so that the response can be routed back. However, exposing the private IP can be a security concern.  
To prevent this, a NAT device is placed in front of private instances. It intercepts outgoing requests and replaces the source IP address with its own public IP address. When a response is received, the NAT device uses its translation table to forward the response to the correct private instance. This table maintains a mapping of internal IP addresses and ports to the NAT’s public-facing IP and port, ensuring proper delivery of responses without exposing internal IPs to the public internet.

### &#9733; Why are we disabling NAT for LAN and DMZ?

- **Preserve Internal IP Visibility**
    - With NAT, the original source IP is often masked or replaced.
    - Disabling NAT allows LAN systems (e.g., logging, monitoring, or SIEM tools) to see the real IP address of DMZ hosts, which is essential for accurate auditing, logging, and security investigations.

- **Simplify Routing and Access Control**
    - Without NAT, routing is handled normally between subnets (e.g., 10.10.1.0/24 ↔ 10.10.200.0/24) using firewall rules.
    - This simplifies firewall policies because you work with consistent IP addresses.

- **Avoid Unnecessary Overhead**
    - NAT adds processing overhead and can introduce complexity when debugging connection issues.
    - Disabling NAT between trusted internal networks reduces this burden.

- **Compatibility with Services**
    - Some services (like log collectors, VoIP, or systems that rely on source IP verification) require real source IPs.
    - NAT can break or complicate those services.

- **Segmentation Without Obfuscation**
    - DMZ is already isolated by being in a separate subnet.
    - You can still enforce strict access controls using firewall rules between LAN and DMZ, without needing to hide IPs with NAT.

### Firewall Rules

I have abstracted the IPs for security concerns:

| Network     | IPs                                                  | Purpose                  | Interface     | Rules                                                                            | Bridge | Devices                        |
|-------------|------------------------------------------------------|--------------------------|---------------|-----------------------------------------------------------------------------------|--------|--------------------------------|
| LAN ↔ DMZ   | IP of my Guacamole-Server ↔ IP of my reverse-proxy   | Internal/Trusted VM network | LAN and WAN   | `Allow` traffic to and from `Guacamole server` and `Reverse proxy` over port `80` and `443` | vmbr1  | Guacamole Server ↔ Reverse-Proxy |
| WAN ↔ DMZ   | IP of my reverse-proxy                               | External access to Internet | DMZ           | `Allow` traffic to and from the reverse proxy to internet via WAN gateway        | vmbr2  | OPNsense (WAN), Router, Proxmox |

Once the rules are configured, you should be able to access the internet on your reverse proxy present in the DMZ, and it should be able to connect and direct traffic to the Guacamole server without any issue.

{{< callout type="warning" >}}
  Portado is still in **active** development. Questions/Suggestions: [open an issue](https://github.com/arbaaz29/portodoXproxhome/issues)
{{< /callout >}}
