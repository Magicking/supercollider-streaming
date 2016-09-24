SuperCollider + ffmpeg + nginx
------------------------------
General information: TODO

![SCS](/sc_streaming.jpg?raw=true)

Usage
-----

* 1 Clone this repository and enter it
```
git clone https://github.com/magicking/supercollider-streaming
cd supercollider-streaming
```

* (OPTIONAL) 2 Put your SSH key(s) in the **authorized_keys** file if you wish to use SSH
```
cat > supercollider-arch/authorized_keys <<HEREDOC
YOURKEYS
HEREDOC
```

* 3 Build the container
```
docker-compose -f docker-compose.yml build
```

* 4 Start the container
```
docker-compose -f docker-compose.yml up
```

* 5 Connect to wetty term at http://127.0.0.1:3000/wetty with your browser

* (OPTIONAL) 5 Connect to the container with SuperCollider using SSH, see ***2***
```
ssh -p 2222 sc@127.0.0.1
```

* 6 Launch scvim (tmux is started automatically)
```
scvim
```

* 7 Start the server and make some sound
```
s.boot; // Press F6 to boot server
{SinOsc.ar(440)}.play; // Press F6 to play a SinOsc at 440hz
```

* 8 Listen using the URL http://127.0.0.1:2280/live/sc.m3u8 on a player
```
vlc http://127.0.0.1:2280/live/sc.m3u8
# or
ffplay http://127.0.0.1:2280/live/sc.m3u8
```

# Known limitations
 * X11 forwarding is needed due to current build options
 * The delay due to configuration of the middleware and used protocol (HLS)
 * Huge overhead due to no optimization of each middleware for this use case either in option or ease of use
 * No windows (meters, help browser, ...)
 * No help file (available at http://doc.sccode.org/)

TODO
----

See TODO file
