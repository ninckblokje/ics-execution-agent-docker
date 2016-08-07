#!/bin/bash

groupadd dba
useradd -d /home/oracle -g dba -m -s /bin/bash oracle

yum -y update
yum -y install tar
