usbmount:
  pkg:
    - installed

/etc/usbmount/usbmount.conf:
  file.managed:
    - source: salt://usbmount/usbmount.conf
    - mode: 644
    - require:
      - pkg: usbmount
