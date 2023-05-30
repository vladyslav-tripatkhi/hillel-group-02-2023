#!/usr/bin/env bash
yum install -y docker
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker
docker run -d --name nginx -p 8080:80 nginx:alpine
