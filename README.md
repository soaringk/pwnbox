# Intro

[20.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.20), [18.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.18), [16.04](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.16) are used as the `base image`, which will be then extended by [Dockerfile.run](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.run).

All using Ubuntu LTS image.

## Explained

* Commonly-used tools were bundle into the base image, such as, `gdb`, `pwndbg`/`gef`, `pwntools`.

* More personalized setup is placed at [Dockerfile.run](https://github.com/soaringk/pwnbox/blob/master/Dockerfile.run), in which I
  * installed some tools in my favor.
  * Switched default shell to `zsh`, using [prezto](https://github.com/sorin-ionescu/prezto).
  * Installed [Libc symbol searcher](https://github.com/soaringk/LibcSearcher).
  * installed personal vim configurations.

* Different versions of glibc are saved at the host machine and mounted on demand (thanks to [glibc-all-in-one](https://github.com/matrix1001/glibc-all-in-one)).

# Building and Running

```
PWNBOX_BASE=20 docker-compose run ctf
```
This command will build the base image (in this case, `pwnbox:20.04`) and then build the extended runtime image, if you don't have them, and give you the interactive shell.

**NOTE**: You should always include `PWNBOX` variable if you want to use `docker-compose` to start up your service.

Maybe export it in the shell profile?
```
echo "export PWNBOX_BASE=18" >> ~/.zshrc
```

## More...

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
   Unnecessary though, since there is no deployment and no team work here :)


# About Images

Usually `18.04`/`20.04` is used, but `16.04`  is reserved just in case.
