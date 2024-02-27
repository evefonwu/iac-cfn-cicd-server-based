#!/bin/bash -xe

# log script output to /tmp 
exec > /tmp/userdata.log 2>&1

# update all packages
yum -y update

# install codedeploy agent
yum -y install ruby
yum install wget  
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent

# install nodejs
cat > /tmp/setup_node.sh << EOF
  echo "Setup NodeJS environment for ec2-user"

  # install nvm v0.39.5 (node version manager)
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  . /home/ec2-user/.nvm/nvm.sh
  . /home/ec2-user/.bashrc
  
  # have nvm install the latest node version
  nvm install --lts

  # Create log directory
  mkdir -p /home/ec2-user/app/logs
EOF

# change file permissions and execute the script
chown ec2-user:ec2-user /tmp/setup_node.sh && chmod a+x /tmp/setup_node.sh
sleep 1; su - ec2-user -c "/tmp/setup_node.sh"