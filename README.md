# Tags and respective Dockerfile

[ubuntu 20.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.20)

[ubuntu 18.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.18)

[ubuntu 16.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.16)

# Including

* debugging:` gdb`, `pwndbg`, `pwntools`, `radare2`, `patchelf`, etc. 
* network: `netcat`, `openvpn`, `nmap`, etc.

Switched default shell to `zsh`, using [prezto](https://github.com/sorin-ionescu/prezto)

glibc and targets are stored at host machine and mounted on demand (thanks to [glibc-all-in-one](https://github.com/matrix1001/glibc-all-in-one)).

[Libc symbol searcher](https://github.com/soaringk/LibcSearcher) can be sometimes useful, but not built into the image due to size concerns.

# Running

```
docker run -it \
--cap-add SYS_PTRACE \
--security-opt seccomp=unconfined \
--mount source=/Users/<yourname>/Workspace/glibc-all-in-one/libs,target=/opt/libs,type=bind,consistency=cached \
--mount source=/Users<yourname>/Desktop/pwn,target=/pwn,type=bind \
--mount source=/Users/<yourname>/Workspace/ctf-challenges/pwn,target=/ctf-challenges,type=bind \
--name ctf \
pwn:18.04
```

or using docker-compose.yml:

```
version: "3"
services:
  ctf:
    image: pwnbox:18.04
    cap_drop:
      - SYS_PTRACE
      # - NET_ADMIN
    security_opt:
      - seccomp:unconfined
    volumes:
      - ~/Workspace/glibc-all-in-one/libs:/opt/glibc:ro
      - ~/Desktop/CTF/pwn:/pwn
      - ~/Workspace/ctf-challenges/pwn:/ctf-challenges
    network_mode: bridge
    stdin_open: true
    tty: true
```

Run `docker-compose run ctf` to enter an interactive shell.

## VS Code Integration

You might want this setting to work with VSCode. [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) can be useful.

You might want to `docker commit <container_name> pwnbox:vscode` after setting up everything. This can save some time.

# About Images

Usually only [18.04, bionic](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.18) is used, but reserved [16.04, xenial](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.16) and [20.04, latest, focal](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.20) just in case ;)
