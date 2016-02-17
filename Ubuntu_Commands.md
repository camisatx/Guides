# Ubuntu Command Line Interface Commands

This file includes a myriad of Ubuntu commands. Hopefully you can pick up one or two commands you never knew about previously.

 Contents:
 - [Connect to a VPS via SSH](#connect-to-a-vps-via-ssh)
 - [System Updates](#system-updates)
    - [Automate System Updates](#automate-system-updates)
 - [Create a System User](#create-a-system-user)
 - [Security](#security)
    - [Security Guide](#security-guide)
    - [UFW Firewall](#ufw-firewall)
    - [SSH Key](#ssh-key)
    - [Disable root and password based login](#disable-root-and-password-based-login)
    - [Fail2Ban](#fail2ban)
    - [Maldet (LMD) with ClamAV](#maldet-lmd-with-clamav)
 - [Monitor Sensor Temperatures](#monitor-sensor-temperatures)


# Connect to a VPS via SSH

From Windows, it is recommended to use cygwin64, putty or Git Bash to connect to a linux machine. Using one of these programs allows you to use native linux commands (i.e. ls), which have no effect within Windows command prompt.

```bash
ssh root@###.###.###.###
```


# System Updates

Fetches the list of available updates

```bash
sudo apt-get update
```

Strictly upgrades the current packages. After entering this command, you will have a chance to preview the updates that will be installed. Ensure that none of them will break any core applications you may be running.

```bash
sudo apt-get upgrade
```

Installs new distribution updates

```bash
sudo apt-get dist-upgrade
```

Remove unused prior packages

```bash
sudo apt-get autoremove
```

## Automate System Updates

### Enable Automatic Updates

By completing these steps, the package can **automatically** update the package list, download/install available upgrades daily, and clean up the download archive weekly.

**Step One** - Install the automatic updater

```bash
sudo apt-get install unattended-upgrades
```

**Step Two** - Configure which updates should be automatically installed. Go through this file, specifying which items should be updated, if autoremove should be enabled, if auto-restart should be enabled, and whether an email should be sent upon errors.

```bash
sudo nano /etc/apt/apt.conf.d/50unattended-upgrades
```

**Step Three** - Specify automatic update period. This file might not exist on a fresh install (if so, use the recommended values below).

```bash
sudo nano /etc/apt/apt.conf.d/10periodic
```

Recommended options to use within this file. Copy and paste the lines below if the file is empty/new.

> APT::Periodic::Update-Package-Lists "1";
>
> APT::Periodic::Download-Upgradeable-Packages "1";
>
> APT::Periodic::AutocleanInterval "7";
>
> APT::Periodic::Unattended-Upgrade "1";


### Get emails about available system updates

Enable cron job to send emails about packages that need updates. Server may need an SMTP package to send out emails.

```bash
sudo apt-get install apticron
#
# Change email and other settings in config file:
sudo nano /etc/apticron/apticron.conf
#
# I.E. Change EMAIL="root@example.com" to a valid email
```


# Create a System User

For security reasons, it is highly recommended to create a non-root user to perform all server admin tasks. These steps will enable you to create a new user with sudo permissions.

Create a new user account

```bash
sudo adduser <new user name>
```

Enable a user to have sudo access

```bash
sudo nano /etc/sudoers.d/<new user name>
#
# Within this file, enter the following line and save it
<new user name> ALL=(ALL) NOPASSWD:ALL
```

Add a [SSH key](#ssh-key) for this new user (especially pertinent if system access via only passwords are disabled).


# Security

## Security Guides

[Introduction to Securing your VPS by Digital Ocean](https://www.digitalocean.com/community/tutorials/an-introduction-to-securing-your-linux-vps)


## UFW Firewall

UFW firewall is a default firewall included with Ubuntu. For most situations, it provides sufficient capabilities.

**Make sure you do not lock yourself out of your VPS by blocking port 22 (SSH)**

[Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-setup-a-firewall-with-ufw-on-an-ubuntu-and-debian-cloud-server) has an excellent guide on setting up UFW.

View the current status of UFW (if it is active or not). Also, use it to verify you've enabled the correct ports.

```bash
sudo ufw status
```

Settings I use on my web servers:

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

To delete an existing rule, run:

```bash
sudo ufw delete allow 80
```


## SSH Key

#### Create SSH key pair on the **local machine**

Keep the default directory, but you can change the specific name of the key pair (useful for application/server specific keys). Also, enter a passphrase for the key pair, if you want extra security.

```bash
ssh-keygen
```

Generate a RSA (default) key with a size of 4096 bits (default of 2048 bits; max of 16384 bits):

```bash
ssh-keygen -b 4096
```

Generate a Ed25519 key (256 bits) (stronger and faster than RSA):

```bash
ssh-keygen -t ed25519
```

#### Place the public key on the **server**

##### [Simple method] (https://wiki.archlinux.org/index.php/SSH_keys)

Copies the specified SSH public key to the ~/.ssh/authorized_keys file on the remote server.

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub <user>@<ip address>
```

##### Manual method

Create a *.ssh* folder in the user's home directory

```bash
cd <user's home directory>
mkdir .ssh
```

Create and add the previously generated public key to a file that will contain all of the public keys the user is able to use. The new file can have multiple public keys, but ensure that there is only one key per line.

```bash
nano .ssh/authorized_keys
#
# Copy the public key from the local machine. It will be in the .pub file.
# Open it with the terminal or Sublime, and paste it on a new line.
```

Restrict access to these new files

```bash
chmod 700 .ssh
chmod 644 .ssh/authorized_keys
```

#### Disable insecure SSH methods

[stribikia](https://stribika.github.io/2015/01/04/secure-secure-shell.html) has an excellent guide on GitHub to securing your SSH connections.


## Disable root and password based login

This is done as a security feature. It forces all users to use a SSH key pair to get access to the server. Password brute force attacks become a moot point after this is done. :)

```bash
sudo nano /etc/ssh/sshd_config
```

Disable password based logins by changing PasswordAuthentication from 'yes' to 'no':

```bash
PasswordAuthentication no
```

Disable root SSH login by changing PermitRootLogin from 'yes' to 'no':

```bash
PermitRootLogin no
```

Restart the SSH service

```bash
sudo service ssh restart
```


## Fail2Ban

#### Install Fail2Ban

```bash
sudo apt-get install fail2ban
```

#### Edit the config files

Copy the default *jail.conf* file to a new file called *jail.local*:

```bash
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

Open the new file:

```bash
sudo nano /etc/fail2ban/jail.local
```

Increase the ban time to a full day (seconds):

```bash
bantime = 86400
```

#### Restart Fail2Ban

```bash
sudo service fail2ban restart
```

#### View status of jails

View the enabled jail list:

```bash
sudo fail2ban-client status
```

View the status of a specific jail (including failed attempts and banned IP addresses):

```bash
sudo fail2ban-client status <jail name>
```


## Maldet (LMD) with ClamAV

Install and setup the Maldet malware scanner using ClamAV binary files (improves speed and malware coverage).

#### Install [Maldet] (https://www.rfxn.com/projects/linux-malware-detect) (Linux Malware Detect; LMD)

```bash
cd /usr/local/src/
sudo wget http://www.rfxn.com/downloads/maldetect-current.tar.gz
sudo tar -xzf maldetect-current.tar.gz
cd maldetect-*
sudo sh ./install.sh
```

#### Configure LMD settings

Open the LMD configuration files:

```bash
sudo nano /usr/local/maldetect/conf.maldet
```

Change *quar_hits*, *quar_clean*, and *clam_av* to **"1"**. Optional: change *quar_susp* to **"1"**.

#### Install ClamAV:

```bash
sudo apt-get install clamtk clamav
```

#### Test install

```bash
sudo maldet -d
sudo maldet -u
sudo maldet -a /home/
```

Make sure that LMD finds the ClamAV binary files. Look for this in the output from running "maldet -a /":

> maldet(####): {scan} found clamav binary at /usr/bin/clamscan, using clamav scanner engine...


# Monitor Sensor Temperatures

Install the sensor packages

```bash
sudo apt-get install lm-sensors sensors-applet
```

Detects all the sensors in the system

```bash
sudo sensors-detect
```

View the current temperatures

```bash
sensors
```

Display sensor temperatures every second, highlighting differences

```bash
watch -n 1 -d sensors
```
