#### Dockerized Emacs with GUI(Mac, Windows, GNU/Linux and your browser)

##### *Images are clickable*

[![http://i.imgur.com/rONW3c3.jpg](http://i.imgur.com/B1gvpmK.jpg)](http://i.imgur.com/rONW3c3.jpg)
[![http://i.imgur.com/mjl9ALQ.jpg](http://i.imgur.com/j6TO942.jpg)](http://i.imgur.com/mjl9ALQ.jpg)
[![http://i.imgur.com/RB46TA9.jpg](http://i.imgur.com/PCpbVg0.jpg)](http://i.imgur.com/RB46TA9.jpg)

[docker-x11-bridge](https://github.com/JAremko/docker-x11-bridge) + a web browser
[![https://github.com/JAremko/docker-x11-bridge/raw/master/img/demoHD.jpg](https://github.com/JAremko/docker-x11-bridge/raw/master/img/demo.jpg)](https://github.com/JAremko/docker-x11-bridge/raw/master/img/demoHD.jpg)


#### Why?
  - Reap the benefits of Emacs and other GNU/Linux tools on Windows/MacOS machines
  - Use [docker hub](https://hub.docker.com/) to auto-build your environment and store full backups for free
  - Build once and work with the same development environment everywhere
  - Run untrusted/risky code in the tunable sandbox with CPU/network/disk quotas
  - Try new tools, experiment and roll back changes when something goes wrong
  - Share your setup with others or extend someone else’s development environment
  - Run multiple Emacs instances on the same machine isolated
  - An easy way to swap Emacs version (`emacs26`,`emacs25`,`emacs-snapshot`) for debugging
  - [Pause](https://docs.docker.com/engine/reference/commandline/pause) container to free resources temporarily
  - [Checkpoint & Restore](https://github.com/docker/docker/blob/1.13.x/experimental/checkpoint-restore.md) - maybe the fastest way to start a “heavy” environment
  - Friendly for networks with low upload speed/quotas

#### Tags:
 - `latest`  [dockerfiles/emacs26](https://github.com/JAremko/docker-emacs/blob/master/Dockerfile.emacs26)
 - `emacs25`  [dockerfiles/emacs25](https://github.com/JAremko/docker-emacs/blob/master/Dockerfile.emacs25)
 - `testing` [dockerfiles/snapshot](https://github.com/JAremko/docker-emacs/blob/master/Dockerfile.snapshot)
 - `alpine` [dockerfiles/alpine](https://github.com/JAremko/docker-emacs/blob/master/Dockerfile.alpine) - *[Emacs build](https://pkgs.alpinelinux.org/package/edge/community/x86_64/emacs) on [Alpine Linux](https://www.alpinelinux.org/) small (around 300mb uncompressed) but can be glitchy*

*If you need a different Emacs version/configuration checkout [Silex/docker-emacs](https://github.com/Silex/docker-emacs)*

#### How to use
First get [docker](https://docs.docker.com/engine/installation/) for your OS.
Then you can use one of the images as a base([FROM](https://docs.docker.com/engine/reference/builder/#/from)) for your [Dockerfile](https://docs.docker.com/engine/reference/builder/).
[Simple example](https://github.com/JAremko/docker-emacs-example), [Spacemacs distribution](https://github.com/syl20bnr/spacemacs/tree/develop/layers/%2Bdistributions/spacemacs-docker).
It will allow you to install and backup additional software/package dependencies. With [Dockerfile ADD](https://docs.docker.com/engine/reference/builder/#add) instruction
you can extract your `.emacs.d` from archives and remote repositories like GitHub using URL.
Also you can simply run one of the images:

##### MacOS:
Get [`XQuartz`](https://www.xquartz.org)

```
open -a XQuartz
```
In the XQuartz preferences, go to the “Security” tab and make sure you’ve got “Allow connections from network clients” ticked
```
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $ip
docker run -ti --name emacs\
 -e DISPLAY=$ip:0\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 -v <path_to_your_.emacs.d>:/home/emacs/.emacs.d\
 -v <path_to_your_workspace>:/mnt/workspace\
 jare/emacs emacs
```
*[source](https://fredrikaverpil.github.io/2016/07/31/docker-for-mac-and-gui-applications/)*

*[other method](https://github.com/chanezon/docker-tips/blob/master/x11/README.md)*

##### Windows
Get [Cygwin](https://www.cygwin.com/) with `xinit`, `xorg-server` and optionaly [`winpty`](https://github.com/rprichard/winpty)(to run Emacs container with `-t`)
```
export DISPLAY=<your-machine-ip>:0.0
startxwin -- -listen tcp &
xhost + <your-machine-ip>
```

```
docker run --name emacs\
 -e DISPLAY="$DISPLAY"\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 -v <path_to_your_.emacs.d>:/home/emacs/.emacs.d\
 -v <path_to_your_workspace>:/mnt/workspace\
 jare/emacs emacs
 ```
 Or with `-ti` via `winpty`
 ```
winpty docker run -ti --name emacs\
 -e DISPLAY="$DISPLAY"\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 -v <path_to_your_.emacs.d>:/home/emacs/.emacs.d\
 -v <path_to_your_workspace>:/mnt/workspace\
 jare/emacs emacs
 ```
*[source](http://manomarks.github.io/2015/12/03/docker-gui-windows.html)*
*You can use [@ninrod 's setup](https://www.reddit.com/r/emacs/comments/7a63r4/emacs_in_win10linuxdockerxserver_combo/)*

##### GNU/Linux
*`UID` and preferably `UNAME` should match the host's user id.
Also make sure that `$DISPLAY` variable is set*
```
docker run -ti --name emacs -v /tmp/.X11-unix:/tmp/.X11-unix:ro\
 -e DISPLAY="unix$DISPLAY"\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 -v <path_to_your_.emacs.d>:/home/emacs/.emacs.d\
 -v <path_to_your_workspace>:/mnt/workspace\
 jare/emacs emacs
```
That's it! Now you should see Emacs window.

###### If it doesn't work

You may need to allow local connection for the user
`UNAME` should match the hosts user id.
```
xhost +si:localuser:<UNAME>
```
Or allow local connection from the container's hostname(This should work with any `UID`)
```
xhost +local:`docker inspect --format='{{ .Config.Hostname }}' emacs`
```
*[source](http://stackoverflow.com/questions/25281992/alternatives-to-ssh-x11-forwarding-for-docker-containers)*

##### Also you can run it with [docker-x11-bridge](https://github.com/JAremko/docker-x11-bridge)
###### Pros:
  - Same client for GNU/Linux, Windows and MacOS + web browser
  - Persistent server (you can connect and disconnect without disrupting Emacs)
  - Interactive screen sharing [demo](https://imgur.com/ijdSuX6)
  - Use Emacs in web-browser (O_O) [demo](https://imgur.com/wDLDMZN)

###### Cons:
  - Lag spikes with some OSes

##### Basic docker commands to get you started:
  - `docker rm -f emacs` - remove `emacs` container
  - `docker restart emacs` - restart `emacs` container
  - `docker rmi -f jare/emacs` - remove `jare/emacs` image
  - `docker pull jare/emacs` - get newer `jare/emacs` version
  - `docker images -a` - list all images
  - `docker ps -a` - list all containers
  - `docker run ... jare/emacs` - run the [default command](https://github.com/JAremko/docker-emacs/blob/master/Dockerfile#L45)
  - `docker run -ti ... jare/emacs /bin/bash` - start bash
  - `docker exec emacs /usr/bin/emacs` - start `/usr/bin/emacs` in the running `emacs` container
  - `docker logs emacs` - print `emacs` container's logs
  - `docker run ... -p 8080:8080 ... jare/emacs` - access container's server from localhost:8080
  - `docker cp <from_my_local_machine_path> emacs:/<to_my_emacs_container_path>`
  - `docker cp emacs:/<from_my_emacs_container_path> <to_my_local_machine_path>`
  -  Manage data in containers with [Docker volumes](https://docs.docker.com/engine/tutorials/dockervolumes/). Example:
    -  `docker volume create --name my-workspace`
    -  `docker run ... -v my-workspace:/mnt/workspace ... jare/emacs`
    -  `docker run ... -v my-workspace:/home/developer/workspace ... jare/vim-bundle`
