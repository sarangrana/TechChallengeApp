#Install Jenkins
sudo amazon-linux-extras install epel -y
sudo yum update -y
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install jenkins java-1.8.0-openjdk-devel -y
sudo systemctl start jenkins
systemctl status jenkins
sudo systemctl enable jenkins

#Setup Jenkins server's further steps as per https://linuxize.com/post/how-to-install-jenkins-on-centos-7/#setting-up-jenkins