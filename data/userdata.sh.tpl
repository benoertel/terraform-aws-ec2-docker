#!/usr/bin/env bash
set -euxo pipefail

echo "[INFO] Pulling docker image"
aws ecr get-login --registry-ids ${registry_id} --no-include-email --region eu-central-1 | sh
${userdata_pull_images}

echo "[INFO] Writing docker-compose file"
cat <<EOF > /var/docker-compose.yml
${docker_compose_content}
EOF

echo "[INFO] Running docker-compose"
ln -s /var/docker.env /var/.env
cd /var && docker-compose up --detach

echo "[INFO] Trigger ASG lifecycle hook"
INSTANCE_ID=$(ec2metadata --instance-id)
echo "[DEBUG] AWS instance id: $${INSTANCE_ID}"

AWS_AVAILABLILITY_ZONE=$(ec2metadata --availability-zone)
echo "[DEBUG] AWS availability zone: $${AWS_AVAILABLILITY_ZONE}"

ASG_NAME=$(aws ec2 describe-tags \
--filters \
"Name=resource-id,Values=$${INSTANCE_ID}" \
"Name=tag:aws:autoscaling:groupName,Values=*" \
--query "Tags[*].Value" \
--output text \
--region "eu-central-1")
echo "[DEBUG] AWS ASG name: $${ASG_NAME}"

echo "[INFO ] Reporting ASG startup lifecycle as finished"
aws autoscaling complete-lifecycle-action \
--auto-scaling-group-name $${ASG_NAME} \
--instance-id $${INSTANCE_ID} \
--lifecycle-action-result CONTINUE \
--lifecycle-hook-name docker_ready \
--region eu-central-1 || true
