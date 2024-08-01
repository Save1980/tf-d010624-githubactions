resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.large"
  vpc_security_group_ids = [aws_security_group.example.id]
  key_name               = var.key_name
  user_data              = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt upgrade -y
              sudo su 
              sed -i 's/#Port 22/Port 234/' /etc/ssh/sshd_config
              systemctl daemon-reload
              systemctl reload ssh
              service ssh restart 
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              cat <<EOFC > /home/ubuntu/docker-compose.yaml
              version: '3'
              services:
                sonarqube:
                  image: sonarqube:latest
                  ports:
                    - "9000:9000"
                  networks:
                    - sonarnet
                  environment:
                    - SONARQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/sonar
                    - SONARQUBE_JDBC_USERNAME=sonar
                    - SONARQUBE_JDBC_PASSWORD=sonar

                postgres:
                  image: postgres:latest
                  environment:
                    - POSTGRES_USER=sonar
                    - POSTGRES_PASSWORD=sonar
                  networks:
                    - sonarnet

              networks:
                sonarnet:
              EOFC
              sudo docker-compose -f /home/ubuntu/docker-compose.yaml up -d
              EOF

  tags = {
    Name = "Terraform-SonarQube-Demo"
  }
}