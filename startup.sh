#!/bin/bash

STATE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/state" -H "Metadata-Flavor: Google")
ZONE=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/zone" -H "Metadata-Flavor: Google")

# Server is rebooting
if [ $STATE = "init" ]; then
  
  # Installing latest packages
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install -y build-essential

  # Installing NVM and node
  export NVM_DIR=/home/ubuntu/.nvm
  curl https://raw.githubusercontent.com/creationix/nvm/v0.24.0/install.sh | bash
  echo "source /home/ubuntu/.nvm/nvm.sh" >> /home/ubuntu/.bashrc
  echo "nvm use 0.10" >> /home/ubuntu/.bashrc
  source /home/ubuntu/.nvm/nvm.sh
  nvm install 8.0
  npm install -g forever

  # Getting code from github
  cd /home/ubuntu
  git clone https://github.com/screenshotjy/gcloud_demo.git

  # Marking the instances as "ready"
  gcloud compute instances add-metadata `hostname` --metadata state=ready --zone $ZONE
fi
  
# Starting Server
cd /home/ubuntu/gcloud_demo
forever -al /var/log/demo.log start index.js 
exit

