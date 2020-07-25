# Tags and respective Dockerfile

[20.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.20)

[18.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.18)

[16.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.16)

all based on Ubuntu LTS image.

# Including

* debugging: `gdb`, `pwndbg`, `pwntools`, `radare2`, `patchelf`, commonly used compiling, sys_call packages, etc.

* Switched default shell to `zsh`, using [prezto](https://github.com/sorin-ionescu/prezto)

* Different versions of glibc are saved at the host machine and mounted on demand (thanks to [glibc-all-in-one](https://github.com/matrix1001/glibc-all-in-one)).

* [Libc symbol searcher](https://github.com/soaringk/LibcSearcher) can be (sometimes) useful, but not built into the image due to storage concerns.

# Running example

```
docker run -it \
--cap-add SYS_PTRACE \
--security-opt seccomp=unconfined \
-v <foo>/glibc-all-in-one/libs:/opt/glibc:ro \
-v <foo>/pwn:/pwn \
--name ctf \
pwnbox:18.04
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
      -  <foo>/glibc-all-in-one/libs:/opt/glibc:ro
      -  <foo>/pwn:/pwn
    network_mode: bridge
    stdin_open: true
    tty: true
```

NOTE: Run `docker-compose run ctf` to enter an interactive shell.

Use `--privilege` flag if you need to edit `/proc`.

## VS Code Integration

If you want this setting to work with VSCode. Check 👉 [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

You might want to `docker commit <container_name> pwnbox:vscode` after setting up everything. It can save you some time.

# About Images

Usually `18.04`/`20.04` is used, but `16.04`  is reserved just in case ;)
