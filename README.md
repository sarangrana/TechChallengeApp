# Servian Take Home Test

This repository is created as a part of Servian Tech Challenge.
---

1. [Architecture Diagram](#1-architecture-diagram)
2. [Tool Stack](#2-tool-stack)
3. [Pre-Requisites](#3-pre-requisites)
    - [GitHub Repository](#github-repository)
    - [AWS Account With Active Subscription](#aws-account-with-active-subscription)
    - [AWS S3 Bucket and AWS Dynamo DB](#aws-s3-bucket-and-dynamo-db)
    - [Jenkins Server](#jenkins-server)
    - [Build Server](#build-server)
    - [GitHub Webhook](#github-webhook)
4. [Current Implementation](#4-current-implementation)
    - [Github Repo](#github-repo)
    - [Jenkins Pipeline](#jenkins-pipeline)
    - [Terraform](#terraform)
    - [Kubernetes](#kubernetes)
5. [Challenges](#6-challenges)
6. [To Do Items](#7-to-do-items)

---

## 1. Architecture Diagram

![image](https://user-images.githubusercontent.com/36162846/152697194-9cd719b5-f490-4415-8a81-79df2a75f5ef.png)


---

## 2. Tool Stack

For this Tech Challange below tools have been used in the solution.
- GitHub
- GitHub Webhook
- Jenkins Pipeline
- Terraform
- AWS Cloud
- AWS S3
- AWS EC2
- AWS Dynamo DB
- AWS RDS
- AWS EKS

---

## 3. Pre-Requisites

### GitHub Repository

You will need a [github](https://github.com/) repositry for the source control management of the code files.
### AWS Account With Active Subscription

Create an [AWS account](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) with active subscription. For this technical challenge I have used [free tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all) AWS account.
### AWS S3 Bucket and AWS Dynamo DB

In this example I am setting up S3 bucket as terraform backend. For this S3 bucket creation is required. We will need to create a dynamo DB table to ensure locking mechanism to avoid over writiting of state file.
Detailed steps can be viewd at [this link](https://www.terraform.io/language/settings/backends/s3).
### Jenkins Server

Here in this example I am using jenkins for CD job. Installation steps of Jenkins can be found at [given link](https://linuxize.com/post/how-to-install-jenkins-on-centos-7/).

I have created a [script](https://github.com/sarangrana/TechChallengeApp/blob/master/setup_jenkins_server.sh) to install jenkins on server which needs to be followed by manual steps from [here](https://linuxize.com/post/how-to-install-jenkins-on-centos-7/#setting-up-jenkins)

### Build Server

In this example, our jenkins server is acting as build server also. We can create a slave node also as a build server and can be attached with Jenkins master for dedicated job runs.

To create build sever, I have used [this script](https://github.com/sarangrana/TechChallengeApp/blob/master/setup_build_server.sh).

### GitHub Webhook
To trigger a pipleine on merge with master, I have setup a github webhook which will have the URL of Jenkins server. 
GitHub Webhook and Jenkins integration steps can be referred at [given link](https://www.blazemeter.com/blog/how-to-integrate-your-github-repository-to-your-jenkins-project)

---

## 4. Current Implementation

### Github Repo

All the files created as a part of this technical challange has been placed to repository [https://github.com/sarangrana/TechChallengeApp](https://github.com/sarangrana/TechChallengeApp)

### Jenkins Pipeline

The Jenkins pipeline code can be viewed at [given link](https://github.com/sarangrana/TechChallengeApp/blob/master/Jenkinsfile) of repo.

Secrets are managed in jenkins which can be used on any slave as those are stored on master.
The secrets which i have used are as below,

- github-user-token
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- postgre_db_password

Here i have disabled Jenkins login so that if someone want to refer jenkins pipeline on jenkins server, they can directly click on below link and have a look.

Jenkins Job : [Jenkins Job Master](http://ec2-18-219-201-252.us-east-2.compute.amazonaws.com:8080/job/servian-cd-pipeline-techchallengeapp-main/)

Jenkins Build Pipeline : [Jenkins Infra Creation Pipeline](http://ec2-18-219-201-252.us-east-2.compute.amazonaws.com:8080/job/servian-cd-pipeline-techchallengeapp-main/1/console)

Jenkins Pipeline To Destory Infra : [Jenkins Infra Deletion Pipeline](http://ec2-18-219-201-252.us-east-2.compute.amazonaws.com:8080/job/servian-cd-pipeline-techchallengeapp-main/)
### Terraform

For the infra creation i have used terraform as config management tool. Terraform can be used with multi cloud deployment and have good documentation for most of the resource type.

Terraform Repo Location : [sarangrana/TechChallengeApp Terraform Repo](https://github.com/sarangrana/TechChallengeApp/tree/master/terraform)

### Kubernetes

I have used kubernetes for deployment on EKS Cluster. Kubernets is one of the most powerful container orchestration tools due to its benifits of deployment and services 

Due to limitation of time I have used YAML files to create deployment, service and secrets. 
This can be done via Terraform Kubernetes resource as well. 

Kubernetes Repo Location : [sarangrana/TechChallengeApp Kubernetes Repo](https://github.com/sarangrana/TechChallengeApp/tree/master/kubernetes)

---

## 5. Challenges

The main challenge i face is my jenkins server is frequently overloaded due to having t2.micro type EC2 instance as i have used the AWS free tire account, which require frequent restarts.

---

## 6. To Do Items

Due to time limitation below items are not implemented yet in the given solution.

- Find a way to dynamically add Postgre Password to Application inside kubernetes
- Attach a AWS Load Balancer to Kubernetes service
- Replace kubernetes YAML with Terraform Kubernetes Resource
