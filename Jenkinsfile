pipeline {
  environment {
    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    imagename = "sarangrana/servian"
    registryCredential = 'sarangrana-dockerhub'
    dockerImage = ''
  }
  agent any
parameters {
        choice(
            choices: ['Build-Infra' , 'Deployment'],
            description: 'For the first time you should select Build-Infra to create infrastructure,later on this pipeline should be used for deployment of application',
            name: 'REQUESTED_ACTION')
  }
  stages {
  stage('Pre-Requisits') {
    when {
                expression { params.REQUESTED_ACTION == 'Build-Infra' }
    }
    steps {
         sh '''#!/bin/bash
                 whoami
                 ls -la
                 pwd
                 aws configure set aws_access_key_id={$AWS_ACCESS_KEY_ID} aws_secret_access_key={$AWS_SECRET_ACCESS_KEY}
                 aws s3 ls
                 chmod 777 setup_build_server.sh
                 ./setup_build_server.sh
         '''
      }
    }
  stage('Terraform Initialize') {
    when {
                expression { params.REQUESTED_ACTION == 'Build-Infra' }
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
                expression { params.REQUESTED_ACTION == 'Build-Infra' }
    }  
    steps{
        dir('terraform') {
         sh "terraform plan"
        }
      }
    }
  stage('Terraform Apply') {
    when {
                expression { params.REQUESTED_ACTION == 'Build-Infra' }
    }    
    steps{
        dir('terraform') {
         sh "terraform apply -auto-approve"
        }
      }
    }
   stage('Terraform Destroy') {
    when {
                expression { params.REQUESTED_ACTION == 'Build-Infra' }
    }
    steps{
        dir('terraform') {
         sh "terraform destroy -auto-approve"
        }
      }
    }
   stage('Building Docker Image') {
      steps{
        script {
          dockerImage = docker.build imagename
        }
      }
    }
   stage('Pushing Docker Image To Regitry') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push("$BUILD_NUMBER")
             dockerImage.push('latest')
          }
        }
      }
    }
   stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $imagename:$BUILD_NUMBER"
         sh "docker rmi $imagename:latest"

      }
   }
   stage('Deploy on Kubernetes') {
      steps{
        script {
          echo "Kubernetes Code will Come here"
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
