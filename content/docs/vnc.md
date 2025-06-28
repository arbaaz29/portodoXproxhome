---
title: VNC
weight: 7
---

### Notes before setting up VNC:

1. It is better for performance if you are able to assign a static address to the VNCserver host so that the setup communication can be streamlined.
2. If you are not able to assign a static address to the VNCserver Host, you will need to keep on changing the IP address while connecting to the server (in case the DHCP lease ends or the machine reboots onto a new IP address) 
3. **Never set up a VNC server as the root user.** If you do and the server is compromised, the attacker will have full control over the system.
4. VNC creates a configuration for the user who installs it. For instance, if user1 installs VNC, the configuration files will be created under user1's account. You’ll just need to set up a password for remote login. Then, you can log in as user1 using the password you set.

## VNC Setup:

### Prerequisite:

1. A desktop environment and a display manager#
    1. I went for Xfce and lightdm as it is lightweight
    
    ```bash
    sudo apt update
    sudo apt upgrade
    sudo apt install xfce4 xfce4-goodies # desktop environment
    # verify if xfce is installed properly
    which startxfce4
    # You should see a path to startxfce4 binary
    sudo apt install lightdm lightdm-gtk-greeter # Display manager
    ```
    
2. VNC server normally uses a port range of 5900+.
3. I went for a lightweight VNC server,  TightVNCserver to expose my application. 
4. TightVNC server will open a port on the host according to the configuration
5. Follow the steps below to initialize and start vncserver (tightvnc): 
    
    ```markdown
    # steps:
    # 1. Once installation is successful create a password for the remote environmet
    
    vncpasswd # set a passwor for remote login user
    
    # 2. start the application in default condition to check if you are able to access anything over port 5901 
     vncserver :1 # this will start vnc server on port 5901
    # Alternatively
     vncserver :2 # this will start vnc server on port 5902
    # while connecting you will need to specify the ip address:5902
    
    # 3. Create xstartup script and make it executable. This script will initialize the host remote desktop when a connection is opened
    # Paste the bellow attached Script in ~/.vnc/xstartup, create ~/.vnc/xstartup if not present
    sudo nano ~/.vnc/xstartup
    chmod +x ~/.vnc/xstartup
    ```
    
    ```bash
    #!/bin/bash
    unset SESSION_MANAGER
    unset DBUS_SESSION_BUS_ADDRESS
    
    # Load system resources
    xrdb $HOME/.Xresources 2>/dev/null
    xsetroot -solid grey
    
    # Auto-detect and start the default desktop environment
    if command -v startxfce4 >/dev/null 2>&1; then
        exec startxfce4
    elif command -v mate-session >/dev/null 2>&1; then
        exec mate-session
    elif command -v startkde >/dev/null 2>&1; then
        exec startkde
    elif command -v gnome-session >/dev/null 2>&1; then
        exec gnome-session
    elif command -v startlxde >/dev/null 2>&1; then
        exec startlxde
    else
        # Fallback to basic window manager
        exec xfwm4
    fi
    ```
    

### Daemon service (optional, if you want persistence for VNCserver):

1. VNC doesn't start automatically at boot. To make it persistent, create a systemd service for your user
2. Make edits in the following script according to your username for the VNC remote user:
    
    ```markdown
    #Create the service. You need to be a sudoer for performing the below actions
    sudo nano /etc/systemd/system/tightvncserver@.service
    
    #Paste the following script and replace username with VNC remote user in
    # /etc/systemd/system/tightvncserver@.service
    
    [Unit]
    Description=TightVNC Server
    After=network.target
    
    [Service]
    Type=forking
    User=username
    Group=username
    WorkingDirectory=/home/username
    
    PIDFile=/home/username/.vnc/%H:%i.pid
    ExecStartPre=-/bin/sh -c '/usr/bin/vncserver -kill :%i > /dev/null 2>&1'
    ExecStart=/usr/bin/vncserver -depth 24 -geometry 1920x1080 :%i
    ExecStop=/usr/bin/vncserver -kill :%i
    Restart=on-failure
    RestartSec=5
    SuccessExitStatus=0 1
    
    [Install]
    WantedBy=multi-user.target
    
    ```
    
3. Save the script, reload the daemon, and start the service. Once the service is up and running, enable the daemon service for vncserver:
    
    ```bash
    sudo systemctl daemon-reexec
    sudo systemctl daemon-restart
    sudo systemctl start tightvncserver@1.service # the one tells the script to open port 5901
    sudo systemctl enable tightvncserver@.service # enables it on boot
    ```
    

# Note :

1. VNC communicates in plain text, so if you don't trust the network, it's safer to host the VNC server locally on the target machine instead of exposing it on the network. 
2. Then, use SSH to establish a secure connection by port-forwarding the VNC port to any local port on your own machine. 
    
    ```bash
    ssh -L 5901:localhost:5901 user@remote-machine
    ```
    
3. Then, connect to localhost:5901 using your VNC client.


{{< callout type="warning" >}}
  Portado is still in **active** development. Questions/Suggestions: [open an issue](https://github.com/arbaaz29/portodoXproxhome/issues)
{{< /callout >}}