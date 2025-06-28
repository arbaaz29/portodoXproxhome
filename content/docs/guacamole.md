---
title: Portado
weight: 8
---

[Let's setup Portado !!!!!!!](https://github.com/arbaaz29/guacamole-docker-compose)

### Overview

Portado is a flavour of Apache Guacamole. Apache Guacamole is a clientless remote desktop gateway that allows users to access their desktops and servers from a web browser, without needing to install any software or plugins. It supports standard remote access protocols such as VNC, RDP, and SSH.

- Guacamole Client (Web App):

    - Written in HTML5 and runs in a browser.

    - Acts as the front end for users to connect to remote machines.

- Guacamole Server (guacd):

    - A daemon that handles the communication between the web app and remote desktop protocols like VNC/RDP/SSH.

    - Acts as a proxy, translating between the browser and the remote service.

- Users access Guacamole through a URL, log in, and can manage or access their remote systems all from the browser.

### Features

- Clientless Access

    - No plugins or clients needed; access is entirely browser-based using HTML5.

- Secure Remote Access

    - Guacamole can be hosted behind a VPN or exposed securely over HTTPS.

    - Supports multi-factor authentication (MFA) via extensions or LDAP/DUO integrations.

- Cross-Platform

    - Works on any device with a modern browser, including smartphones and tablets.

- Protocol Support

    - RDP (Remote Desktop Protocol)

    - VNC (Virtual Network Computing)

    - SSH (Secure Shell)

    - Support for file transfer (SFTP in SSH, clipboard, drive redirection with RDP).

- Multi-user Management

    - Role-based access with user/group permissions.

    - Integrates with LDAP, CAS, SAML, or MySQL authentication systems.

- File Transfer and Clipboard Sharing

    - Upload/download files during a session.

    - Share clipboard contents between local and remote machines.

- Session Recording

    - Record user sessions for auditing or training purposes (configurable).

- Custom Extensions

    - Extend functionality using Java-based plugins (e.g., 2FA, branding, analytics, etc.).

- Resource Management

    - Organize connections into groups.

    - Assign permissions to users for fine-grained access control.


### Configuration

- A Ubuntu server with docker for providing containers run-time environment.

- Allow port 8080 in IPtables/ufw host based firewall.

- Use the following `docker compose` file to automate the process of setting up guacd, guacamole, and MariaDB.

    - guacd (Guacamole Daemon)

        - Role: Handles protocol-level communication (RDP, VNC, SSH).

        - Configuration:

            - Uses the official guacamole/guacd image.

            - Connected to internal Docker network guacnetwork_compose.

            - Always restarts if stopped (restart: always).

    - mariadb (Database)

        - Role: Stores user credentials, connection configurations, history, etc.

        - Configuration:

           - Sets root password and initializes:

                - guacamole_db database.

                - Credentials (optional user: guacamole_user, but currently unused).

            - Mounts initdb volume to run initial DB schema scripts.

            - Connected to guacnetwork_compose.
    
    - guacamole (Web UI)

        - Role: Web interface users log into to access remote desktops.

        - Configuration:

           - Environment variables set:

                - DB connection (MYSQL_*)

                - GUACD_HOSTNAME to link with guacd

            - Exposes port 8080 on host for browser access.

            - Mounts the initdb volume to apply the Guacamole DB schema.
            
            - Connected to guacnetwork_compose.

    -  initdb (Volume)

        - Role: Provides initial SQL schema to the database.

        - Mounts To:

            - MariaDB: /docker-entrypoint-initdb.d (initializes DB)

            - Guacamole: /opt/guacamole/extensions/... (schema for JDBC auth)

- Here is the link for [docker-compose.yml](https://github.com/arbaaz29/guacamole-docker-compose)

- After setting up the containerized environment, verify you are able to access Guacamole via browser at `ubuntu.ip:8080`

    - default username - `guacadmin`

    - default password - `guacadmin`

- Log in scan and configure `TOTP` and change guacadmin's password. Go to settings and create a new user with admin access that can add new connections and users.

- Test if you are able to log in as the new user before you disable the `guacadmin` user.

![user](/Guacamole/user.png)

- After verifying the user login, create a new connection:

    - Name your connection and select the protocol to connect to the instance.

    - Under parameters, the network hostname should be your instance's IP address and the port that is exposed for remote login.

    - Under the authentication block, in the Username field, enter the username of the instance user that is configured for remote login. In this case, `user1`, and the password will be the one that was set up using the `vncpasswd` command, which is `makeshiftpassword`.

![connection](/Guacamole/connection.png)

![connection1](/Guacamole/connection1.png)

- After setting up connections, go to the homepage and double-click on the new connection, in this case, Tiger. You should be able to interact with your machine via the browser window.

![homepage](/Guacamole/homepage.png)

![window](/Guacamole/window.png)

- Voila! Guacamole has been set up successfully, and now you are able to access your machines securely from anywhere without the need for a VPN.

### Optional:

- In case you want to customize your sign-in page, user page, or any other pages of your application, you can perform the following steps:

    - Get the `Guacamole.war` file from `guacaomole/guacamole` container:
    ```bash
        docker cp guacamole/guacamole:/opt/guacamole/webapp .
        #In case of any errors:
        docker run -d -name guacamole guacamole/guacamole
        docker cp guacamole:/opt/guacamole/webapp .
    ```
- This will output the `webapp` directory in your current directory.

- Extract the contents from the `guacamole.war` file present inside `webapp`. You will need `JDK (Java Development Kit)` for the following steps:

    ```bash
        mkdir guacamole_contents
        cd guacamole_contents
        jar -xf ../guacamole.war 
    ```

- If you want to change the profile image and favicon, you will need to replace `guac-tricolor.svg` for the `profile` and `logo-64.png` and `logo-144.png` for the `favicon`.

- In case you want to change the content of the website, you can modify it from `transliteration/en.json`.

- Once the configurations are finalized, re-zip the contents:
    ```bash
        jar -cf guacamole.war -C guacamole_contents .
    ```

- Now, create a custom container image with these modifications:

    ```dockerfile
        FROM guacamole/guacamole

        COPY ./guacamole.war /opt/guacamole/webapp

        EXPOSE 8080

    ```

    ```bash
        docker build -t repo_name/guacamole .

        docker push repo_name/guacamole
    ```

- Update the guacamole service’s image name with repo_name/guacamole and recompose the deployment. The changes will be visible when the cache expires.


# Docker-compose file:

- [https://github.com/arbaaz29/guacamole-docker-compose](https://github.com/arbaaz29/guacamole-docker-compose)

{{< callout type="warning" >}}
  Portado is still in **active** development. Questions/Suggestions: [open an issue](https://github.com/arbaaz29/Portado/issues)
{{< /callout >}}