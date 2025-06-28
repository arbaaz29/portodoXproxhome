---
title: Proxy
weight: 7
---

Configuring the reverse proxy to handle the incoming traffic.

### &#9733; Note
- I have an active subscription with Cloudflare, taking the domain rights for the domain [arbaazjamadar.com](https://arbaazjamadar.com).  
- I can create valid SSL/TLS certificates as part of this subscription package.  
- In case you can't create valid SSL/TLS certificates, you can opt for self-signed certificates. Although this is not suggested for internet-exposed services.

### What is Reverse Proxy?

A reverse proxy is a server that sits in front of one or more web servers, intercepting requests from clients. This is different from a forward proxy, where the proxy sits in front of the clients. With a reverse proxy, when clients send requests to the origin server of a website, those requests are intercepted at the network edge by the reverse proxy server. The reverse proxy server will then send requests to and receive responses from the origin server.

To sum it up, a reverse proxy sits in front of an origin server and ensures that no client ever communicates directly with that origin server.

### Nginx-Reverse-Proxy:

- The instance hosts a Debian OS that is configured with `Docker`. The [Nginx-Reverse-Proxy](https://nginxproxymanager.com/setup/#using-mysql-mariadb-database) is set up with Docker for its ease of management, quick deployment, and ability to be integrated continuously.

- The instance is exposed securely to the Cloudflare network with the help of Cloudflare tunnels. A DNS record has been created to direct all the requests to this instance.

- The incoming traffic’s encryption as well as management will be handled by `Nginx-Reverse-Proxy` hosted on the Debian instance.

- Cloudflare will encrypt the traffic from the internet till the `Nginx-Reverse-Proxy` hosted on the Debian instance. The `Nginx-Reverse-Proxy` will handle the encryption of traffic within the homelab environment.

### Configuration:

- You can create valid SSL/TLS certificates with Let's Encrypt Certbot for the subdomains, or you can import them from the Cloudflare dashboard.

- Create a proxy host, directing the traffic for a subdomain to the desired instance. In this case, direct the traffic for the subdomain `guac.arbaazjamadar.com` to the IP of the Guacamole server within the LAN. Put the IP of your instance in the Forward Hostname/IP field.  
  ![Proxy](/proxy/proxy.png)

- Create a custom rule to redirect path `/` to `http://guac.ip/guacamole`, so that you don't have to type "guacamole" every time you try to get to the instance in the URL field.  
  ![Custom](/proxy/custom.png)

- Apply the imported/created SSL certificate on the connection. Do not force SSL certificates, as the Guacamole server has not been configured with SSL certificates.  
  ![ssl](/proxy/ssl.png)

- Verify the connection by going to the subdomain.

&#9733; Note:

- I am port forwarding to port 8080 because I am using port 80 and port 443 for other applications. As long as you are not using port 80 and 443 for anything, you should be good with this configuration. Otherwise, you will have to allow traffic over port 8080 between LAN and DMZ for the Guacamole server and Nginx-Reverse-Proxy in the firewall.

{{< callout type="warning" >}}
  Portado is still in **active** development. Questions/Suggestions: [open an issue](https://github.com/arbaaz29/Portado/issues)
{{< /callout >}}
