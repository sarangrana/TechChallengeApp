pipeline {
  environment {
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    postgre_db_password = credentials('postgre_db_password')
    DOCKER_REGISTRY = credentials('DOCKER_REGISTRY')
    imagename = '{$DOCKER_REGISTRY}/techchallengeapp:latest'
    registry = credentials('DOCKER_REGISTRY')
    registryCredential = credentials('sarangrana-dockerhub-user-token')
    eks_cluster_name = ''
  }
  agent any
parameters {
        choice(
            choices: ['BuildInfraAndDeploy', 'DeleteInfra'],
            description: 'For the first time you should select Build-Infra to create infrastructure,later on this pipeline should be used for deployment of application',
            name: 'REQUESTED_ACTION')
  }
  stages {
  stage('Pre-Requisits') {
    steps {
         sh '''#!/bin/bash
                 whoami
                 ls -la
                 pwd
                 aws configure set aws_access_key_id={$AWS_ACCESS_KEY_ID} aws_secret_access_key={$AWS_SECRET_ACCESS_KEY}
                 aws s3 ls
                 #chmod 777 setup_build_server.sh
                 #./setup_build_server.sh
         '''
      }
    }
  stage('Terraform Initialize') {
    when {
                expression { params.REQUESTED_ACTION == 'BuildInfraAndDeploy' || params.REQUESTED_ACTION == 'DeleteInfra'}
    }     
    steps{
        script {
                 sh "ls -la"
                 sh "pwd"
                 dir('terraform') {
                    sh "terraform init"
                 }
        }
      }
    }
  stage('Terraform Plan') {
    when {
                expression { params.REQUESTED_ACTION == 'BuildInfraAndDeploy' }
    }  
    steps{
        dir('terraform') {
         withCredentials([string(credentialsId: 'postgre_db_password', variable: 'VAR_POSTGRE_DB_PASSWORD')]) {
         sh '''
         terraform plan -var='postgre_db_password={$VAR_POSTGRE_DB_PASSWORD}'
         '''
         }
        }
      }
    }
  stage('Terraform Apply') {
    when {
                expression { params.REQUESTED_ACTION == 'BuildInfraAndDeploy' }
    }    
    steps{
        dir('terraform') {
         withCredentials([string(credentialsId: 'postgre_db_password', variable: 'VAR_POSTGRE_DB_PASSWORD')]) {
         sh '''
         terraform apply -auto-approve -var='postgre_db_password={$VAR_POSTGRE_DB_PASSWORD}'
         terraform output eks_cluster_name > eks_cluster_name.txt
         '''
         script { eks_cluster_name = readFile('eks_cluster_name.txt').trim() }
         }
        }
      }
    }
  stage('Terraform Destroy') {
    when {
                expression { params.REQUESTED_ACTION == 'DeleteInfra' }
    }    
    steps{
        dir('terraform') {
         withCredentials([string(credentialsId: 'postgre_db_password', variable: 'VAR_POSTGRE_DB_PASSWORD')]) {
         sh '''
         terraform destroy -auto-approve -var='postgre_db_password={$postgre_db_password}'
         '''
         }
        }
      }
    }
   stage('Deploy on Kubernetes') {
    when {
                expression { params.REQUESTED_ACTION == 'BuildInfraAndDeploy' }
    }  
    steps{
        dir('kubernetes') {
         sh "echo ${eks_cluster_name}"
         sh "aws eks update-kubeconfig --name ${eks_cluster_name} --region us-east-2"
         sh "curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/kubectl"
         sh "chmod +x ./kubectl"
         sh "./kubectl apply -f servian-app-secret.yaml -f servian-app-deployment.yaml -f servian-app-service.yaml"
         sh "./kubectl get pods -o wide"
         sh "./kubectl get deployment"
         sh "./kubectl get services"
        }
      }
    }
  }
  post { 
        always { 
            cleanWs()
        }
    }
}
