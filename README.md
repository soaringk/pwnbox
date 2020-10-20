# Pwnbox

Your toolbox for pwn in docker.

## Building and Running

Clone this repo and run the following command:
```
PWNBOX_BASE=20 docker-compose run ctf
```

This command will give you the an interactive shell, and if the image does not exist, it will try to build it for you (in this case, `pwnbox:base.20` and `pwnbox:runtime.20` based on `ubuntu:20.04`).

PWNBOX_BASE is used to specify the version of ubuntu LTS, currently only accepts `16`, `18`, `20`.

## Explain

Commonly used packages were built into the base image, such as, `gdb`, `pwndbg`/`gef`, `pwntools`, etc.

[Dockerfile.run](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.run) is my personal setup, in which I:
* installed my favorite tools.
* Switched default shell to `zsh`, using [prezto](https://github.com/sorin-ionescu/prezto).
* installed my [vim configurations](https://github.com/soaringk/I_Vim).
* etc.

Different versions of glibc are saved on the host and mounted on demand (check [glibc-all-in-one](https://github.com/matrix1001/glibc-all-in-one) for more info).

**NOTE**: You should always include `PWNBOX_BASE` variable if you want to use `docker-compose` to start up the `ctf` service. You may export it in your shell profile:
```
echo "export PWNBOX_BASE=20" >> ~/.zshrc
```

## More Commands

* Build all services
  ```
  PWNBOX_BASE=20 docker-compose build
  ```

* Build specific service
  ```
  docker-compose build basebox.18
  ```

* without `docker-compose`
  ```
  docker run -it \
  --cap-add SYS_PTRACE \
  --security-opt seccomp=unconfined \
  -v <foo>/glibc-all-in-one/libs:/opt/glibc:ro \
  -v <foo>/pwn:/pwn \
  --name ctf \
  pwnbox:18.04
  ```

NOTE: Use `--privilege` flag if you need to edit `/proc`.

## VS Code Integration

If you want this setting to work with VSCode. Check 👉 [Remote-Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

1. You might want to `docker commit <container_name> pwnbox:vscode` after setting up everything. It can save you some time.
2. Or you can use the `.devcontainer.json`. Reference 👉 [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers).
   Unnecessary though, since there is neither deploying nor team work involved here :)

## About Images

Usually `18.04`/`20.04` is used, but `16.04`  is reserved just in case.

# References
[20.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.20)
[18.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.18),
[16.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.16)
