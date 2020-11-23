#!/bin/bash
INSTALL_DIR="/app/vendor/awscli"
chmod +x /app/vendor/awscli-bundle/install
/app/vendor/awscli-bundle/install -i $INSTALL_DIR
chmod u+x $INSTALL_DIR/bin/aws

mkdir ~/.aws

cat >> ~/.aws/credentials << EOF
[default]
aws_access_key_id = $AWS_S3_ACCESS_KEY
aws_secret_access_key = $AWS_S3_SECRET
EOF

cat >> ~/.aws/config << EOF 
[default]
region = $AWS_S3_REGION
EOF