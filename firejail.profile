blacklist /usr/local
blacklist /boot
blacklist /media
blacklist /mnt
blacklist /opt
blacklist /var

whitelist /dev/null
whitelist /dev/random
whitelist /dev/urandom
whitelist /dev/zero

private-etc nginx,ssl

private-tmp
noexec /tmp
shell none
caps.drop all
