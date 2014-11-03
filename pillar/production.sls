env_name: production
hostname: media.local
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
