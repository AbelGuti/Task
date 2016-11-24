# Task


##Start with local configuration
Because we dont have a public DNS, we need to set those lines
>54.165.37.138	domain1.com

>54.165.37.138	domain2.com

>54.165.37.138	domain3.com

on
>/etc/hosts

Next, you can enter to:

-http://domain1.com/index.php

-http://domain2.com/index.php

-http://domain3.com/index.php


## Architecture Diagram

![alt tag](https://github.com/AbelGuti/Task/blob/master/arqui.png)

##How it works?
I work in a t2.micro EC2 instance ok AWS. The instance has a Ubuntu 16.04 OS and a Apache server with 3 virtual hosts: domain1.com,
domain2.com, domain3.com. Each vh has a index.php file who request the credentials (port, password) to make a connection string for
MySql docker instance, futher the docker name instances y request it too. This data its given to ETCD Docker. ETCD works like a 
key-value storage, so the php client make a request for a especific value. To create a MySql docker we need to run the 
~/createMysqlDocker.sh, this sh need 3 parameters, the first one is the docker name, the second a password and the third a port
where the docker will be listen for a request. Example:
>~/createMysqlDocker myDocker super_password 3306

Also this file set the credentials to the ETCD docker.
When a Mysql docker its up, we can connect using:
>sudo docker exec -it myDocker /bin/bash

next we can to connect to mysql:
>mysql -u root --password=super_password

In the mysql console, we need to run the script.sql file.

Once this is done, a client can be connect to:
- domain1.com/index.php
- domain2.com/index.php
- domain3.com/index.php

##Install Apache and configure VH
We get apache
>sudo apt-get update

>sudo apt-get install apache2

Create a directories
>sudo mkdir -p /var/www/domain1.com/public_html

>sudo mkdir -p /var/www/domain2.com/public_html

>sudo mkdir -p /var/www/domain3.com/public_html


Grant permission
>sudo chown -R $USER:$USER /var/www/domain1.com/public_html

>sudo chown -R $USER:$USER /var/www/domain2.com/public_html

>sudo chown -R $USER:$USER /var/www/domain3.com/public_html

>sudo chmod -R 755 /var/www


Install php and create index.php file in the directories...
Create a virtual host file on:
>sudo nano /etc/apache2/sites-available/domain1.com.conf

>sudo nano /etc/apache2/sites-available/domain2.com.conf

>sudo nano /etc/apache2/sites-available/domain3.com.conf


Set this text in all of them by changing the "domain1.com"
```
<VirtualHost *:80>
    ServerName domain1.com
    ServerAlias www.domain1.com
    DocumentRoot /var/www/domain1.com/public_html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Use a2ensite to set avaible our sites
>sudo a2ensite domain1.com.conf

>sudo a2ensite domain2.com.conf

>sudo a2ensite domain3.com.conf


Restart apache2 service
>sudo service apache2 restart

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
Comand to run a MySQL container
>docker run --name my-container-name -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql/mysql-server:tag

Comand to ruan a ETCD cluster container
>export PUBLIC_IP=54.165.37.138

>docker run -d -p 8001:8001 -p 5001:5001 quay.io/coreos/etcd:v0.4.6 -peer-addr ${PUBLIC_IP}:8001 -addr ${PUBLIC_IP}:5001 -name etcd-node1


