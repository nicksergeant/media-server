env_name: vagrant
hostname: media-local.local
deploy_user: vagrant

users:
  -
    name: vagrant
    groups:
      - deploy
      - wheel

ssh:
    port: 22
