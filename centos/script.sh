#!/bin/bash
sleep 2
#### fix systemd centos #####
yum swap -y fakesystemd systemd 
yum install -y systemd-devel
#### update system ####
yum update -y
/bin/bash
