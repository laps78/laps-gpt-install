#!/bin/bash
rm -r laps-gpt-install && echo "folder delete successful"
sudo deluser gpt_bot --remove-all-files && echo "user gpt_bot anihilated"
git clone https://github.com/laps78/laps-gpt-install && echo "repo cloned successfull"
cd laps-gpt-install
chmod +x install.sh && echo "install.sh activated"
./install.sh
