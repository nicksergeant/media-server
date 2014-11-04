build-essential:
  pkg.installed:
    - pkgs:
      - build-essential

iptables:
  pkg.installed:
    - pkgs:
      - iptables

system:
  pkg.installed:
    - pkgs:
      - cmake
      - curl
      - usbmount
      - git
      - htop
      - mercurial
      - python-dev
      - tree
      - libpq-dev
