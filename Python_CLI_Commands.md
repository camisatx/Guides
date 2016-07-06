# Python Command Line Interface Commands

This file covers many of the common commands used with Python through the command line interface. Traditionally, one could only find such a collection by either going to the docs, or by following a tutorial/guide.

The purpose of consolidating snippets of common commands is to lessen the obstacle of using command lines in the programming environment.

As a beginner, using the command line interface can be a daunting process (as opposed to simply using an interpreter), thus I hope this helps beginners build their confidence using these tools.


# PIP

[pip](https://pip.pypa.io/en/stable/) is a package management system that is used to install and manage libraries with Python.

Install the specified library

```bash
pip install <specified library>
```

Install all required libraries specified by requirements.txt (applicable for virtual environments)

```bash
pip install -r requirements.txt
```

List all the installed libraries within the active Python interpreter

```bash
pip list
```

List all the installed libraries **and** their version numbers

```bash
pip freeze
```

Save a list of all the installed libraries and their version numbers to requirements.txt . This is useful when you are using virtual environments (virtualenv), and you need to specify the libraries to install (including dependencies).

```bash
pip freeze > requirements.txt
```


# Virtual Environments (virtualenv)

Virtual environments are used to isolate libraries for different projects by creating virtual Python environments for each project.

[virtualenv](http://docs.python-guide.org/en/latest/dev/virtualenvs/) is a library that can easily create these virtual Python environments in a specified folder.

pip install the virtualenv library (not included in the Python standard library)

```bash
pip install virtualenv
#
# Install virtualenv into a Python version which isn't the system default
# Windows: /c/Users/<User>/<Python Install Folder>/Scripts/pip.exe install virtualenv
# Linux: /home/<User>/<Python Install Folder>/bin/pip install virtualenv
```

Make a directory one folder up (from your main project code) for the virtual environment called 'virtualenv'

```bash
mkdir ../virtualenv
```

Create the virtual environment in a specified folder ('virtualenv', which we created above)

```bash
virtualenv ../virtualenv
#
# Creating a virtual environment from a different Python version (i.e. Python 2.7 while Python 3.4 is the system default)
# Windows: /c/Users/<User>/<Python Install Folder>/python.exe /c/Users/<User>/<Python Install Folder>/Lib/site-packages/virtualenv.py ../virtualenv
```

Activate the virtual environment

```bash
# OSX/'nix: source ../virtualenv/bin/activate
#
# Windows: source ../virtualenv/Scripts/activate
```

Deactivate the virtual environment (once finished using it)

```bash
deactivate
```

Check which python is running (shows the complete folder path)

```bash
which python
```


# Psycopg2

### Install psycopg2

##### Ubuntu

First, install libpq-dev:
```bash
sudo apt-get install libpq-dev python-dev
```
Might also require:
```bash
sudo apt-get install postgresql-server-dev-all
```

Then use PIP to install psycopg2:
```bash
pip install psycopg2
```

##### CentOS
```bash
sudo yum install python-devel postgresql-devel
pip install psycopg2
```

##### Windows
It is easiest to use the prebuilt binary Psycopg wheel provided by Christoph Gohlke on his [Python Extension Packages](http://www.lfd.uci.edu/~gohlke/pythonlibs/) page.


# Fabric

[Fabric](http://www.fabfile.org/) is a **Python 2.7 ONLY** library for application deployment and system administration tasks. It provides operations on a local or remote machine (via ssh).

Install pycrypto (dependency)

```bash
Windows 64bit: easy_install http://www.voidspace.org.uk/downloads/pycrypto26/pycrypto-2.6.win-amd64-py2.7.exe
```

Install Fabric

```bash
pip install fabric
```

Deploy (using the class 'deploy' within fabfile.py)

```bash
fab deploy:host=<user name>@appname-staging.server.com
```