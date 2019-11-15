---
title: 在 Ubuntu 18.04 上通过 Minikube 安装 Kubernetes
date: 2019-11-15 10:41:18
categories:
  - Kubernetes
tags:
  - Kubernetes
  - K8S
  - minikube
  - ubuntu
---

最近一直在学习 Kubernetes，并自购了一台服务器进行 Kubernetes 的部署学习，在这过程中踩了一些坑，所以把这些安装过程记录下来，以便后续进行回顾。

通过本文，我们将会学习到如何在 Ubuntu 18.04 LTS 上通过 Minikube 安装一个单节点 Kubernetes 测试环境。

<!-- more -->

---

## 安装必要工具

```shell
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
```

由于国内网络的不稳定性，我们需要将相关镜像源切换为国内阿里云的镜像。

## 添加镜像相关秘钥

```shell
curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
```

## 添加阿里云镜像

```shell
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
sudo apt-get update
```

在阿里云镜像地址中貌似没有找到 18.04(bionic) 的源，不过也无所谓，就用 16.04(xenial) 即可。

## 安装 Docker、kubectl

```shell
sudo apt-get install -y docker.io kubectl
```

## 配置阿里云 Docker 镜像加速器

这里采用了阿里云的镜像加速器（需要阿里云账号进行登录），地址：阿里云 -> 容器镜像服务 -> 镜像中心 -> 镜像加速器

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
"registry-mirrors": ["https://xxxxxx.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

以上配置是阿里云镜像加速器中的配置，本文中这一块儿是直接从阿里云镜像加速器中的配置说明复制的，大家根据自己的情况在阿里云镜像加速器中去复制。

## 安装 Minikube

目前最新 v1.5.2，查看最新版：https://github.com/kubernetes/minikube/releases
如果curl无法下载，也可以通过手动下载并上传到服务器的形式

```shell
curl -Lo minikube https://github.com/kubernetes/minikube/releases/download/v1.5.2/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
```

## 使用 Minikube 创建 Kubernetes

```shell
minikube start --vm-driver=none --apiserver-ips=your-server-ip --image-mirror-country cn \
 --iso-url=https://kubernetes.oss-cn-hangzhou.aliyuncs.com/minikube/iso/minikube-v1.5.2.iso \
 --registry-mirror=https://xxxxxx.mirror.aliyuncs.com \
 --image-repository=https://registry.aliyuncs.com/google_containers
```

此处的 `registry-mirror` 是阿里云的镜像加速器的 mirror，换成你自己的即可; `apiserver-ips` 则是你服务器的IP，因为如果需要远程访问的话，需要将服务器的IP进行暴露，同样换成你自己的服务器IP即可

如果不出意外的话，由 minikube 创建的单机 Kubernetes 环境就成功了。
