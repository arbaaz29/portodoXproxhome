---
title: Cloudflare Tunnel
weight: 6
---

I have opted for Cloudflare because of its ease of use, good pricing, and performance optimization due to its edge locations.

### Pre-requsities:

- [Cloudflare ZTNA account](https://one.dash.cloudflare.com/), free to signup.

-  [Cloudflare DNS](https://cloudflare.com/): You can use their DNS for free even if you are registered with another domain provider. In my case, I am already a Cloudflare customer, so it is easy for me to integrate Cloudflare services.

- Debian Host: As of now, Cloudflare Tunnel supports Debian OS and other enterprise Linux OSs but not Ubuntu.

### Configuration

- Sign in to your Cloudflare ZTNA account, and click on `Create a tunnel` under Networks → Tunnels.  
  ![cldflare](/cloudflare/cldflare.png)

- After clicking Next, select **cloudflared** and name your tunnel.  
  ![cloudflared](/cloudflare/cldflared.png)  
  ![create](/cloudflare/create.png)

- After entering the name, follow the installation steps to install **cloudflared** on your Debian host.  
  ![setup](/cloudflare/setup.png)

- This is the final step: set up a subdomain or domain for the instance.  
  ![domain](/cloudflare/setup_domain.png)

- You have successfully configured the tunnel and domain. Verify, you should be able to see nginx congratulations page when you query the domain, if you have configured the proxy properly.



{{< callout type="warning" >}}
  Portado is still in **active** development. Questions/Suggestions: [open an issue](https://github.com/arbaaz29/Portado/issues)
{{< /callout >}}