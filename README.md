# sharethis
Instantly host the current folder over HTTPS with a [firejailed](https://github.com/netblue30/firejail) nginx.

### Limitations
This script only works, when the to-be-shared path does not contain characters, that crash the sed command, from which the config gets generated (such as: `~\'"`). Only use with sane paths.
(The nginx config gets checked, before the server even starts.)


### Usage
* Check out the source code to somewhere on your disk
* Navigate to the folder, that you want to share over your local network
* run `full/path/to/sharethis.sh`
* the first time, it will generate a HTTPS certificate
* (you can force it to generate a new one by deleting `~/.cache/sharethis`)
* when it is hosting, point your browser to https://127.0.0.1:4443 to download the files (replace the IP accordingly for LAN)
* firejail ensures, that nginx only has access to the shared folder, in case it gets exploited
* `sharethis.sh` will show all access and error logs from nginx directly in the terminal

```
ollieparanoid@laptop ~ % cd ~/share
ollieparanoid@laptop ~/share % ~/code/sharethis/sharethis.sh
Starting sandbox
Generating a 4096 bit RSA private key
.......................
writing new private key to 'server.key'
-----

Port:
4443

Certificate SHA256:
6C:6E:FE:15:2D:94:F2:29:3F:A0:ED:B6:F5:AA:CE:7E:BB:6A:16:10:DC:0F:A3:20:16:10:4E:F8:C4:14:1F:95

Webroot:
/home/ollieparanoid/share

Press ^C to stop
^C
Sandbox stopped
```

### TODO
Implement commandline arguments, that do the following:
* host on custom port
* disable autoindex
* protect with password (another argument to generate a new one)
* generate a new HTTPS certificate
