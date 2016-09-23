# TODO

See TODO file

# USAGE

* 0 Clone this repository
```
git clone https://github.com/magicking/supercollider-streaming
```

* 2 Put your key(s) in the **authorized_keys** file
```
cat > supercollider-arch/authorized_keys <<HEREDOC
YOURKEYS
HEREDOC
```

* 3 Build the container using
```
docker-compose -f docker-compose.yml build
```

* 4 Build the container using
```
docker-compose -f docker-compose.yml up
```

* 5 Connect to the container with SuperCollider and launch scvim (tmux is started automatically see ~sc/.bashrc)
```
ssh -p 2222 sc@127.0.0.1
scvim
```

* 6 Start servers and make some sound
```
s.boot // F6 to boot server
{SinOsc.ar(440)}.play // F6 to make sin wave at 440hz
```

* 7 Listen to using the URL http://127.0.0.1:2280/live/sc.m3u8
```
vlc http://127.0.0.1:2280/live/sc.m3u8
# or
ffplay http://127.0.0.1:2280/live/sc.m3u8
```

# Known limitations
 * X11 forwarding is needed due to current build options
 * The delay due to configuration of the middleware and used protocol (HLS)
