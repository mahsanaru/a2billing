## Prerequisites
This code was tested on a cluster with the following versions:
  - Kubernetes: v1.26.0
  - Containerd: v1.6.6
  - Helm: v3.11.1
  - PHP image version: 5.6
  - Ingress: Nginx ingress controller

## Default passwords and access info

As the installation instructed, I have set the following values in the database chart:
 - Database name is: mya2billing
 - Database user is: a2billinguser
 - User password is: a2billing

## Installation

This repository consists of one chart called a2billing that has dependency on its subchart that is mostly the plain Bitnami MySQL chart, except that an InitContainer was added to its value.yaml file to run the script installdb.sh to import the tables needed for the a2billing application. 
For installing the cluster run the following command in the cloned git directory with the release-name you want:

    ./run.sh release-name

## NOTE

I have added a sample pv.yaml to the DB chart to use for testing purposes. You can remove this line in run.sh.
Ingress does not support TCP or UDP services so for the SIP protocol part, a popular workaround according to this post is to make Nginx ingress controller use the flags --tcp-services-configmap and --udp-services-configmap to point to an existing config map where the key is the external port to use and the value indicates the service to expose using the format: <namespace/service name>:<service port>:[PROXY]:[PROXY]. For this purpose, I have created the needed configmaps in the a2billing charts. IBM has a Voice Gateway for on-premises installation as well. 

## ISSUES
 
  - The default value used for several timestamp fields for MySQL was not correct, I've updated the php code as well as sql files with a correct value.
  - MySQL service is currently up and running and I could connect it using client, but there are some errors in php services about connecting to MySQL.
