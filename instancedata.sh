#!/bin/bash

# metadata hostname
curl -w "\n" http://169.254.169.254/latest/meta-data/hostname/ > metadata.txt

# metadata iam info
curl -w "\n" http://169.254.169.254/latest/meta-data/iam/ >> metadata.txt

# metadata security groups
curl -w "\n" http://169.254.169.254/latest/meta-data/security-groups/ >> metadata.txt


