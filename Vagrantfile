Vagrant.configure("2") do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
  config.vm.hostname = "media-local.local"
  config.vm.synced_folder ".", "/var/www/media-server/"
  config.vm.synced_folder "/Volumes/Seagate/", "/media/usb0"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 8080, host: 8080
end
