# Install Docker
sudo amazon-linux-extras install -y docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
sudo systemctl enable docker

# Install Singularity
sudo yum install -y singularity