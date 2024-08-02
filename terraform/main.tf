# resource "aws_instance" "web" {
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t3.large"
#   subnet_id = "subnet-0e7d227d9d31c2d07"
#   vpc_security_group_ids = [aws_security_group.example.id]
#   key_name               = var.key_name
#   user_data              = <<-EOF
#               #!/bin/bash
#               sudo apt update
#               sudo apt upgrade -y
#               sudo su 
#               sed -i 's/#Port 22/Port 234/' /etc/ssh/sshd_config
#               systemctl daemon-reload
#               systemctl reload ssh
#               service ssh restart 
#               sudo apt install docker.io -y
#               sudo systemctl start docker
#               sudo systemctl enable docker
#               sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#               sudo chmod +x /usr/local/bin/docker-compose
#               cat <<EOFC > /home/ubuntu/docker-compose.yaml
#               version: '3'
#               services:
#                 sonarqube:
#                   image: sonarqube:latest
#                   ports:
#                     - "9000:9000"
#                   networks:
#                     - sonarnet
#                   environment:
#                     - SONARQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/sonar
#                     - SONARQUBE_JDBC_USERNAME=sonar
#                     - SONARQUBE_JDBC_PASSWORD=sonar

#                 postgres:
#                   image: postgres:latest
#                   environment:
#                     - POSTGRES_USER=sonar
#                     - POSTGRES_PASSWORD=sonar
#                   networks:
#                     - sonarnet

#               networks:
#                 sonarnet:
#               EOFC
#               sudo docker-compose -f /home/ubuntu/docker-compose.yaml up -d
#               EOF

#   tags = {
#     Name = "Terraform-SonarQube-Demo"
#   }
# }

name: 'Terraform'

on:
  push:
    branches: [ "main" ]

jobs:
  terraform:
    name: 'Terraform'
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{secrets.AWS_SECRET_ACCESS_KEY }}

    runs-on: ubuntu-latest
    environment: dev

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Terraform Init
      uses: hashicorp/terraform-github-actions@master
      with:
        tf_actions_version: 0.14.3
        tf_actions_subcommand: 'init'
        tf_actions_working_dir: '.'
        tf_actions_comment: true

    - name: Terraform plan
      uses: hashicorp/terraform-github-actions@master
      with:
        tf_actions_version: 0.14.3
        tf_actions_subcommand: 'plan'
        tf_actions_working_dir: '.'
        tf_actions_comment: true
      
    - name: Terraform apply
      uses: hashicorp/terraform-github-actions@master
      with:
        tf_actions_version: 0.14.3
        tf_actions_subcommand: 'apply'
        tf_actions_working_dir: '.'
        tf_actions_comment: true
        args: '-auto-approve'