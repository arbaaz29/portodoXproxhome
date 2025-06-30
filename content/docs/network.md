---
title: Network
weight: 3
---

This guide outlines how the network topology is structured within the homelab infrastructure, which is powered by Proxmox VE, OPNsense, Nginx Reverse-Proxy, and Cloudflare Tunnel.

### Overview

![Network](/images/Portado.png)

The Proxmox homelab uses a virtualized network to segment the main network into three subnets:

- **WAN:** 192.168.1.0/24  
- **LAN:** 10.10.1.0/24  
- **DMZ:** 10.10.200.0/24  

An OPNsense virtual firewall routes and filters traffic between these networks, enabling secure connectivity and isolation.

### Topology Components

#### Proxmox VE Host

- An open-source bare-metal virtualization platform — a homelaber's bread and butter.
- Provides virtual bridges (`vmbr0`, `vmbr1`, `vmbr2`). The machines on these bridges will be assigned according to the configurations in OPNsense. These bridges are connected to the OPNsense router as network interfaces. The traffic will be filtered and managed by the OPNsense virtual router and firewall.

#### Virtual Bridges (vmbr)

- **vmbr0** – WAN bridge connected to the router (`192.168.1.0/24`)  
- **vmbr1** – LAN bridge for internal VMs (`10.10.1.0/24`)  
- **vmbr2** – DMZ bridge for exposed services (`10.10.200.0/24`)  

#### OPNsense Firewall (VM)

- Interfaces:  
  - **net0 (WAN):** Connected to `vmbr0`  
  - **net1 (LAN):** Connected to `vmbr1`  
  - **net2 (DMZ):** Connected to `vmbr2`  
- Handles inter-VLAN routing, NAT, firewall rules, SIEM integration, and VPN access.

#### Internal VMs

- **Parrot Desktop VM**  
  - Connected to LAN via `vmbr1`  
- **Nginx-Reverse-Proxy Server**  
  - Connected to DMZ via `vmbr2`  

### External Network

#### Router

- Default Gateway: `192.168.1.1`  
- Provides internet access for the Proxmox host and OPNsense WAN interface.

#### External Access

- Devices on the `192.168.1.1/24` subnet can access the OPNsense WAN.  
- **Cloudflare Tunnel** provides full-tunnel private access. This helps integrate the instances directly into the Cloudflare network. This will later help resolve the DNS query to the instance where `Nginx-Reverse-Proxy` is hosted.

#### Full-Tunnel (Cloudflare)

- Full-tunnel routes traffic from the Cloudflare network to devices through OPNsense.  
- No need to set up NAT port forwarding or anything — the Cloudflare Tunnel automatically routes the traffic from configured instances to the Cloudflare network.  
- Ensures encrypted remote access to the Nginx-Reverse-Proxy in the `DMZ` subnet.

#### Subnet Breakdown

| Network | Subnet           | Purpose                  | Bridge | Devices                           |
|---------|------------------|--------------------------|--------|------------------------------------|
| WAN     | 192.168.1.0/24   | External access to Internet | vmbr0 | OPNsense (WAN), Router, Proxmox   |
| LAN     | 10.10.1.0/24     | Internal/Trusted VM network | vmbr1 | Guacamole Server & Parrot VM      |
| DMZ     | 10.10.200.0/24   | Untrusted services         | vmbr2 | Nginx-Reverse-Proxy               |

### &#9733; Note

After trying out OpenWRT, pfSense, and OPNsense, I have settled on OPNsense due to its ease of use, powerful SIEM and VPN integrations, and robust firewall capabilities.  
Here is a dashboard overview presented in OPNsense — easy to visualize traffic blocked and let in by the firewall.  
![opn](/proxy/opnsense.png)

{{< callout type="warning" >}}
  Portado is still in **active** development. Questions/Suggestions: [open an issue](https://github.com/arbaaz29/Portado/issues)
{{< /callout >}}
