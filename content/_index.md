---
title: Portado
layout: hextra-home
---

{{< hextra/hero-badge >}}
  <div class="hx-w-2 hx-h-2 hx-rounded-full" style="background-color:rgb(2, 185, 70);"></div>
  <span>Hellowww!!! From ProxHome 🙋‍♂️</span>
  {{< icon name="arrow-circle-right" attributes="height=14" >}}
{{< /hextra/hero-badge >}}

<div class="hx-mt-6 hx-mb-6">
{{< hextra/hero-headline >}}
  Welcome to Portado!
{{< /hextra/hero-headline >}}
</div>

<div class="hx-mb-12">
{{< hextra/hero-subtitle >}}
  Take remote control of your machines with a smooth interface
{{< /hextra/hero-subtitle >}}
</div>


<div class="hx-mb-6">
{{< hextra/hero-button text="Documentation" link="/docs/introduction/" >}}
</div>

<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"></div>

{{< hextra/feature-grid >}}
  {{< hextra/feature-card
    title="Portado"
    icon="avacado"
    subtitle="Portado is a custom flavour of Apache Guacamole. Apache Guacamole is a clientless remote desktop gateway that lets users access systems via RDP, VNC, or SSH directly from a web browser. Guacamole also integrates with LDAP and supports two-factor authentication."
  >}}
  {{< hextra/feature-card
    title="CloudFlare Tunnel"
    icon="cloudflare"
    subtitle="Cloudflare Tunnel creates a secure, end-to-end encrypted connection to your Cloudflare network without exposing your service to the public internet. It eliminates the need for port forwarding on your router and simplifies remote access."
  >}}
      {{< hextra/feature-card
    title="OPNsense"
    icon="router"
    subtitle="Securely manage your homelab network with PfSense, a powerful open-source firewall and routing platform. It features advanced firewall rules, traffic shaping, and intrusion detection. Seamlessly integrate VPNs and multi-WAN setups for enhanced control and reliability."
  >}}
  {{< hextra/feature-card
    title="Nginx-Reverse-Proxy"
    icon="proxy"
    subtitle="Nginx Proxy Manager with Web based GUI to help manage routing incoming traffic to your configured services securely, using SSL/TLS encryption and an easy-to-use web interface. Not only that, but it can configure it to create new certificates for subdomains."
  >}}
  {{< hextra/feature-card
    title="TightVNCServer"
    icon="vnc"
    subtitle="TightVNC Server is a lightweight and minimalistic VNC server that allows you to self-host remote desktop access. It enables screen sharing and control over a network using the VNC protocol. Ideal for low-resource systems, it’s simple to set up and use."
  >}}
{{< /hextra/feature-grid >}}
