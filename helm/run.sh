#!/bin/bash
name=$1
# for testing proposes I have added a sample pv for mysql but you should use storage class 
kubectl apply -f ./a2billing/charts/db/pv-test.yaml
kubectl create ns a2billing
helm install $name a2billing/
