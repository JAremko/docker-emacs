## Cross-platform Emacs(GUI)

[![http://i.imgur.com/rONW3c3.jpg](http://i.imgur.com/B1gvpmK.jpg)](http://i.imgur.com/rONW3c3.jpg)
[![http://i.imgur.com/mjl9ALQ.jpg](http://i.imgur.com/j6TO942.jpg)](http://i.imgur.com/mjl9ALQ.jpg)
[![http://i.imgur.com/RB46TA9.jpg](http://i.imgur.com/PCpbVg0.jpg)](http://i.imgur.com/RB46TA9.jpg)

### How to run

First install [docker](https://docs.docker.com/engine/installation/)

#### GNU/Linux
*`UID` and preferably `UNAME` should match the host's user id.
Also make sure that `$DISPLAY` variable is set*
```
docker run -ti --name emacs -v /tmp/.X11-unix:/tmp/.X11-unix:ro\
 -e DISPLAY="unix$DISPLAY"\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 jare/docker-emacs emacs
```
That's it! Now you should see Emacs window.

##### If it doesn't work

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
#### MacOS [Read this beautiful instruction](https://github.com/chanezon/docker-tips/blob/master/x11/README.md)

#### Windows
You will need [Cygwin](https://www.cygwin.com/) with `xinit`, `xorg-server`. Optionaly [`winpty`](https://github.com/rprichard/winpty)(to run Emacs container with `-t`)
```
export DISPLAY=*your-machine-ip*:0.0
startxwin -- -listen tcp &
xhost + *your-machine-ip*
docker run --name emacs\
 -e DISPLAY="unix$DISPLAY"\
 -e UNAME="emacser"\
 -e GNAME="emacsers"\
 -e UID="1000"\
 -e GID="1000"\
 jare/docker-emacs emacs
 ```
*[source](http://manomarks.github.io/2015/12/03/docker-gui-windows.html)*

*Read MacOS setup for extra security tips*

*Or you can use [@ninrod 's vagrant setup](https://github.com/JAremko/docker-emacs/issues/2#issuecomment-260047233)*

# WIP
