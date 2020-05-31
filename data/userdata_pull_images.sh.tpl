docker pull ${registry_url}/${image_name}:${image_tag}
docker tag ${registry_url}/${image_name}:${image_tag} ${image_name}:terraform
