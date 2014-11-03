JSHINT := node_modules/.bin/jshint
JSHINTFLAGS :=--config=.jshintrc --exclude=scripts/make/js-semicolon.js

css_files := $(shell node scripts/make/css-files.js)
js_files := $(shell node scripts/make/js-files.js)
js_src_files := $(shell find public/src server server.js scripts -name '*.js')

pm = /var/www/.virtualenvs/snipt/bin/python /var/www/snipt/manage.py
ssh-server-deploy = ssh deploy@media.local -p 55555
ssh-server-root = ssh root@media.local
ssh-vagrant = ssh vagrant@localhost -p 2222 -i ~/.vagrant.d/insecure_private_key

compile: js css

css: $(css_files)
	@cat $(css_files) > public/media-server.css

db:
	@node scripts/make/init-database.js

deploy: jshint
	@ssh deploy@media.local -p 55555 'cd /var/www/media-server; git pull'
	@ssh deploy@media.local -p 55555 'cd /var/www/media-server; make install'
	@ssh deploy@media.local -p 55555 'cd /var/www/media-server; make compile'
	@ssh deploy@media.local -p 55555 'sudo supervisorctl restart media-server'

install:
	@npm install
	@cd public && bower install

js: $(js_files)
	@cat $(js_files) > public/media-server.js

jshint: $(js_src_files)
	@$(JSHINT) $(JSHINTFLAGS) $(js_src_files)

run: install jshint
	@vagrant up
	@vagrant ssh -c 'sudo supervisorctl restart media-server && sudo supervisorctl tail -f media-server stdout'

salt-server:
	@scp -q -P 55555 -r ./salt/ deploy@media.local:salt
	@scp -q -P 55555 -r ./pillar/ deploy@media.local:pillar
	@$(ssh-server-deploy) 'sudo rm -rf /srv'
	@$(ssh-server-deploy) 'sudo mkdir /srv'
	@$(ssh-server-deploy) 'sudo mv ~/salt /srv/salt'
	@$(ssh-server-deploy) 'sudo mv ~/pillar /srv/pillar'
	@$(ssh-server-deploy) 'sudo salt-call --local state.highstate'

salt-vagrant:
	@scp -q -P 2222 -i ~/.vagrant.d/insecure_private_key -r ./salt/ vagrant@localhost:salt
	@scp -q -P 2222 -i ~/.vagrant.d/insecure_private_key -r ./pillar/ vagrant@localhost:pillar
	@$(ssh-vagrant) 'sudo rm -rf /srv'
	@$(ssh-vagrant) 'sudo mkdir /srv'
	@$(ssh-vagrant) 'sudo mv ~/salt /srv/salt'
	@$(ssh-vagrant) 'sudo mv ~/pillar /srv/pillar'
	@$(ssh-vagrant) 'sudo salt-call --local state.highstate'

server:
	@$(ssh-server-root) 'sudo apt-get update'
	@$(ssh-server-root) 'sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade'
	@$(ssh-server-root) 'sudo apt-get install -y software-properties-common python-software-properties'
	@$(ssh-server-root) 'sudo add-apt-repository -y ppa:saltstack/salt'
	@$(ssh-server-root) 'sudo apt-get update'
	@$(ssh-server-root) 'sudo apt-get install -y salt-minion'
	@scp -q -r ./salt/ root@media.local:salt
	@scp -q -r ./pillar/ root@media.local:pillar
	@$(ssh-server-root) 'sudo rm -rf /srv'
	@$(ssh-server-root) 'sudo mkdir /srv'
	@$(ssh-server-root) 'sudo mv ~/salt /srv/salt'
	@$(ssh-server-root) 'sudo mv ~/pillar /srv/pillar'
	@$(ssh-server-root) 'sudo salt-call --local state.highstate'
	@ssh deploy@media.local -p 55555 'cd /var/www/media-server; make db'

vagrant:
	@vagrant up --provider=vmware_fusion
	@$(ssh-vagrant) 'sudo apt-get update'
	@$(ssh-vagrant) 'sudo apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade'
	@$(ssh-vagrant) 'sudo apt-get install -y software-properties-common python-software-properties'
	@$(ssh-vagrant) 'sudo add-apt-repository -y ppa:saltstack/salt'
	@$(ssh-vagrant) 'sudo apt-get update'
	@$(ssh-vagrant) 'sudo apt-get install -y salt-minion'
	@scp -q -P 2222 -i ~/.vagrant.d/insecure_private_key -r ./salt/ vagrant@localhost:salt
	@scp -q -P 2222 -i ~/.vagrant.d/insecure_private_key -r ./pillar/ vagrant@localhost:pillar
	@$(ssh-vagrant) 'sudo rm -rf /srv'
	@$(ssh-vagrant) 'sudo mkdir /srv'
	@$(ssh-vagrant) 'sudo mv ~/salt /srv/salt'
	@$(ssh-vagrant) 'sudo mv ~/pillar /srv/pillar'
	@$(ssh-vagrant) 'sudo salt-call --local state.highstate'
	@ssh vagrant@localhost -p 2222 -i ~/.vagrant.d/insecure_private_key 'cd /var/www/media-server; make db'

.PHONY: pillar public salt scripts server
