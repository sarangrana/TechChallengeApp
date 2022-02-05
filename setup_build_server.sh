#Install git
sudo yum install git -y
git --version

#Install docker
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl status docker
sudo systemctl enable docker
docker --version

#Install Terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
terraform -version

#Install go
sudo yum install -y golang
go version

#Install AWS CLI
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
aws --version