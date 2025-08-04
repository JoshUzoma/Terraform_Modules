# ----- DEA Naming Convention -----
organization  = "tomss"
team          = "sp"
aws_region    = "us-east-2"
resource_type = "ec2"
purpose       = "sonarqube"
env           = "dev"

# Optional override for instance name
instance_name = ""

# AWS EC2 Key Pair name (for SSH)
key_name = "jtestkey"

# EC2 Instances map
instances = {
  "sonarqube" = {
    ami_id             = "ami-0eb9d6fc9fab44d24"
    instance_type      = "t2.medium"
    subnet_id          = "subnet-0b8d39de125d74c95"

    security_group_ids = ["sg-0737584037937575c"]

   user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y wget unzip java-17-amazon-corretto

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.1.0.73491.zip
unzip sonarqube-10.1.0.73491.zip -d /opt

useradd sonar
chown -R sonar:sonar /opt/sonarqube-10.1.0.73491

cat <<EOT > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube-10.1.0.73491/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube-10.1.0.73491/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube
EOF
  }
}