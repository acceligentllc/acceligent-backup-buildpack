#!/bin/bash

mkdir -p ~/.aws

cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id = $AWS_S3_ACCESS_KEY
aws_secret_access_key = $AWS_S3_SECRET
EOF

cat > ~/.aws/config << EOF 
[default]
region = $AWS_REGION
EOF

export PATH="/app/.awscli/bin:${PATH}"