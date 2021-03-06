# Ubuntu Command Line Interface Commands

This file includes a myriad of Ubuntu commands. Hopefully you can pick up one or two commands you never knew about previously.

### Contents:
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
 - [Storage](#storage)
    - [SSHFS](#sshfs)
 - [System Monitoring](#system-monitoring)
    - [Monitor Sensor Temperatures](#monitor-sensor-temperatures)
 - [Databases](#databases)
    - [PostgreSQL](#postgresql)

I made a [bash script](../master/scripts/new_server_setup) with many of these commands included. This is useful for securing new servers you spin up. Let me know if you think there is anything that should be added to this.


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
sudo usermod -aG sudo <new user name>
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

Copies the specified SSH public key to the ~/.ssh/authorized_keys file on the remote server. **Run this before disabling password authentication (login).**

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

Within the `jail.local` file, increase the ban time from 600 seconds to 86,400 seconds (1 day):

```bash
bantime = 86400
```

Also within the `jail.local` file, increase the find time from 600 seconds to 3,600 seconds (1 hour):

```bash
findtime = 3600
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


# Storage

## SSHFS

SSHFS is a filesystem client to mount and interact with directories and files located on a remote server over a normal ssh connection.

This means that you can use a secure SSH connection to mount a storage device located on a remote computer onto your local machine. That's pretty awesome!

To install sshfs, run:

```bash
sudo apt install sshfs
```

### Mount the Remote Directory

Before mounting the remote directory, create a new folder where you want to mount the folder to.

```bash
mkdir remote_drive
```

Then you can mount the remote directory to this local folder.

```bash
sshfs ubuntu@192.168.0.1:/home/ubuntu/movies ~/remote_drive
```

### Unmount the Remote Directory

When you are finished using the remote directory, you can unmount the remote folder.

```bash
fusermount -u ~/remote_drive
```

[Source](https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh)


# System Monitoring

## Monitor Sensor Temperatures

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


# Databases

## PostgreSQL

### Install the latest PostgreSQL

Add the official PostgreSQL repository for the long-term stable release
```bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
```

Import the GPG key of the repository so that apt can check the validity of the package
```bash
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
```

Update the package list
```bash
sudo apt-get update
```

Install PostgreSQL
```bash
sudo apt-get install postgresql postgresql-contrib
```

Optional - Install pgAdmin3
```bash
sudo apt-get install pgadmin3
```

A new user of 'postgres' is created after PostgreSQL is installed.

Change the password of the new user 'postgres'
```bash
$ sudo passwd postgres
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
```

Change the password of the postgres user within PostgreSQL
```bash
su postgres
psql
ALTER USER postgres PASSWORD 'new_password';
```

### Connect to Postgres Server

Change to the postgres user and start the psql shell
```bash
sudo -u postgres psql
```

Disconnect from the postgres server
```psql
\q
```

Change back from the postgres user
```bash
exit
```

### Change Data Directory

If you need to have Postgres store all databases on a separate disk, you must change the default data directory to a folder on the new disk. I do this so that I can store my data directory on a large RAID storage array instead of the small SSD boot drive.

Andy Wang has an excellent [guide](https://climber2002.github.io/blog/2015/02/07/install-and-configure-postgresql-on-ubuntu-14-dot-04/) on this, which is where I sourced these commands from.

Create a new folder on the storage array where the new Postgres data directory should be stored
```bash
mkdir Database
```

Change the owner of the folder to postgres
```bash
sudo chown -R postgres:postgres /Database
```

Initialize this folder as a Postgres data directory, using the postgres user to perform this task (su postgres)
```bash
su postgres
/usr/lib/postgresql/9.5/bin/initdb -D /Database
exit
```

Stop the Postgres server to prevent issues from arising
```bash
sudo service postgresql stop
```

Update the postgresql.conf file to link to the new data directory
```bash
sudo nano /etc/postgresql/9.5/main/postgresql.conf
```
And change the old data directory link of
```bash
data_directory = 'var/lib/postgresql/9.5/main'
```
to the new data directory folder
```bash
data_directory = '/Database'
```

After saving the file, restart the Postgres server
```bash
sudo service postgresql start
```

### Allow a New User to Get All Database Permissions

Grant all privileges on the current database to the new user for all tables. If any table has any serial columns utilizing sequences, you can grant the new user all privileges for sequences.
 
 For security reasons, it is best to only grant the privileges the new user actually uses.
 
```sql
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO <new user>;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public to <new user>;
```
