# sharethis
Instantly host the current folder over HTTPS with a sandboxed nginx.

### Limitations
This script only works, when the to-be-shared path does not contain characters, that crash the sed command, from which the config gets generated (such as: `~\'"`). Only use with sane paths.
(The nginx config gets checked, before the server even starts.)
