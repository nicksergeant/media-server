env_name: production
hostname: media.sergeant.co
deploy_user: deploy

users:
  -
    name: deploy
    groups:
      - deploy
      - wheel
  -
    name: nick
    groups:
      - deploy
      - wheel

ssh:
    port: 55555
