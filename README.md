### Base image for the Spacemacs-docker(GUI) distribution.

#### Usage example:

Launch server:

``` sh
docker run -ti --rm -v ~/.ssh/pub_rsa:/etc/pub-keys/my.pub -p 22:22 <IMAGE>
``` 
Attach:
``` sh
xpra attach --encoding=rgb --ssh="ssh -p 22" ssh:root@localhost:14
``` 

*Also you can connect via Docker terminal, mosh, ssh or GUI browser.*
