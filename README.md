# Task




## Architecture Diagram

![alt tag](arqusi.png)

##How it works?
I work in a t2.micro EC2 instance ok AWS. The instance has a Ubuntu 16.04 OS, an Apache server and the tool Confd installed.
I use Confd to automate the creation of vhosts on Apache and to create a php page located in /var/www/main/index.php. This directory is used like a symbolic link to be consumed by the vhosts directories.
I have a MySql docker instance, when I create a MySql docker the name of the docker, the port and the password of this its given to ETCD Docker. ETCD works like a key-value storage, so the Confd tool updates two destiny files with the necesary information to create the /var/www/main/index.php file and a script to automate the creation of vhosts.

To create a MySql docker we need to run the 
~/createMysqlDocker.sh, this sh need 3 parameters, the first one is the docker name, the second a password and the third a port
where the docker will be listen for a request. Example:
>~/createMysqlDocker.sh myDocker super_password 3306


To create a vhost we need to run the 
~/addVhost.sh, this sh need 2 parameters, the first one is the name of the key for the etcd instance and the second the value of the key.
Example:
>~/createMysqlDocker.sh domain1.com domain1.com

Also the createMysqlDocker.sh file set the credentials to the ETCD docker.
When a Mysql docker its up, we can connect using:
>sudo docker exec -it myDocker /bin/bash

next we can to connect to mysql:
>mysql -u root --password=super_password

In the mysql console, we need to run the script.sql file.

Once this is done, a client can be connect on any vhost that he was created:
- domain1.com/index.php
- domain2.com/index.php
- domain3.com/index.php
- ...
- ...


##Steps

-Install Apache (go to Section)

-Install PHP (go to Section)

-Install Docker (go to Section)

-Running Docker images (go to Section)

-Load the script.sql (go to Section)

-Install Confd (go to Section)

-Run (ip and port where ETCD docker is linstening)

>sudo confd-0.11.0-linux-amd64 -onetime -backend etcd -node http://54.165.37.138:5001

-Grant permitions to:
>sudo chmod 777 /temp/exe.sh

-Run exe.h and connect to your virtual host :D

If you want to create another VH you only must run the addVhost.sh, execute the confd command and connect.

-Local configuration (go to Section)


##Local configuration
Because we dont have a public DNS, we need to set those lines

>54.165.37.138	domain1.com

>54.165.37.138	domain2.com

>54.165.37.138	domain3.com

>...

>...

on
>/etc/hosts

54.165.37.138 its my ip address, you must changed it by yours

##Install Apache
We get apache
>sudo apt-get update

>sudo apt-get install apache2

Restart apache2 service
>sudo service apache2 restart

##Install PHP

>sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql

Restar apache
>sudo systemctl restart apache2


##Install Docker
Let's update the package database:
>sudo apt-get update

Now let's install Docker. Add the GPG key for the official Docker repository to the system:
>sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

Add the Docker repository to APT sources:
>sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'

Update the package database with the Docker packages from the newly added repo:
>sudo apt-get update

Make sure you are about to install from the Docker repo instead of the default Ubuntu 16.04 repo:
>apt-cache policy docker-engine

Finally, install Docker:
>sudo apt-get install -y docker-engine

Docker should now be installed, the daemon started, and the process enabled to start on boot. Check that it's running:
>sudo systemctl status docker

##Running Docker images

Comand to ruan a ETCD cluster container
>export PUBLIC_IP=54.165.37.138

>docker run -d -p 8001:8001 -p 5001:5001 quay.io/coreos/etcd:v0.4.6 -peer-addr ${PUBLIC_IP}:8001 -addr ${PUBLIC_IP}:5001 -name etcd-node1

54.165.37.138 its my ip address, you must changed it by yours

pull Mysql image
>docker pull mysql/mysql-server

Grant permitions to createMysqlDocker.sh
>sudo chmod 777 createMysqlDocker.sh

Run createMysqlDocker.sh, example 
>./createMysqlDocker.sh MyMysql super_password 3306

You must modify the ip address on createMysqlDocker.sh file beacuse 54.165.37.138 its my ip address, you must changed it by yours

##Load the script.sql

When a Mysql docker its up, we can connect using:
>sudo docker exec -it MyMysql /bin/bash

next we can to connect to mysql:
>mysql -u root --password=super_password

In the mysql console, we need to copy the content of the script.sql file.

##Intall Confd
We move to
>cd /usr/local/bin

Get the bin
>sudo wget https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64

Grant permitions to exec.
>sudo chmod +x confd

Create two directories
>sudo mkdir -p /etc/confd/{conf.d,templates}


Create the next files:
>sudo nano /etc/confd/conf.d/config.toml 


```
[template]
src = "config.conf.tmpl"
dest = "/tmp/config.conf"
keys = [
        "/name",
        "/port",
        "/psswd",
]
```


>sudo nano /etc/confd/conf.d/vhost.toml 

```
[template]
src = "vhost.conf.tmpl"
dest = "/tmp/exe.sh"
keys = [
        "/vhosts",
]
```

>sudo nano /etc/confd/templates/config.conf.tmpl

and copy the text of the config.conf.tmpl file from the repository.


>sudo nano /etc/confd/templates/vhost.conf.tmpl

and copy the text of the vhost.conf.tmpl file from the repository.





