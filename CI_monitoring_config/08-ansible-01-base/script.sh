#!/bin/bash

set -e

echo "Running containers in docker..."
docker run -dit --name ubuntu pycontribs/ubuntu:latest
docker run -dit --name fedora pycontribs/fedora
docker run -dit --name centos7 pycontribs/centos:7

echo "Running ansible-playbook..."
ansible-playbook -i ./playbook/inventory/prod.yml ./playbook/site.yml --ask-vault-pass

sleep 20

echo "Stopping containers ..."
docker stop fedora ubuntu centos7