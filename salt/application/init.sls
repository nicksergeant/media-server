/var/www:
  file.directory:
    - user: {{ pillar.deploy_user }}
    - group: deploy
    - mode: 775
    - require:
      - user: {{ pillar.deploy_user }}
      - group: deploy

{% if pillar.env_name != 'vagrant' %}

/var/www/media-server:
  file.directory:
    - user: {{ pillar.deploy_user }}
    - group: deploy
    - mode: 775
    - require:
      - group: deploy

  git.latest:
    - name: https://github.com/nicksergeant/media-server.git
    - target: /var/www/media-server
    - user: deploy

{% endif %}

/home/{{ pillar.deploy_user }}/tmp:
  file.absent

npm-install:
  npm.bootstrap:
    - name: /var/www/media-server
    - runas: {{ pillar.deploy_user }}
    - require:
      - pkg: build-essential
      - pkg: nodejs
      - pkg: system

bower:
  cmd.run:
    - user: {{ pillar.deploy_user }}
    - cwd: /var/www/media-server/public
    - names:
      - bower install

/etc/supervisor/conf.d/media-server.conf:
  file.managed:
    - source: salt://application/media-server.supervisor.conf
    - template: jinja
    - makedirs: True
  cmd.run:
    - name: supervisorctl restart media-server

media-server-site:
  file.managed:
    - name: /etc/nginx/sites-available/media-server
    - source: salt://application/media-server.nginx.conf
    - template: jinja
    - group: deploy
    - mode: 755
    - require:
      - pkg: nginx
      - group: deploy

enable-media-server-site:
  file.symlink:
    - name: /etc/nginx/sites-enabled/media-server
    - target: /etc/nginx/sites-available/media-server
    - force: false
    - require:
      - pkg: nginx
  cmd.run:
    - name: service nginx restart
    - require:
      - pkg: nginx
