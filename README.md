# `env-data-modeling`

Netbeheer Nederland environment for information modeling and generating documentation and schemas.

## Features

The `run.sh` script should be used to instantiate a container. It runs the container for you while taking care of:

* installing all dependencies for working with LinkML, Antora, Git, etc.
* mounting the project working directory in the container in the `/project` directory
* mount the host user's SSH key directory in the container
* mapping the host user to the target container environment (UID, GID and name)
* setting the Git user name and e-mail as globally (in the `--global` sense) configured in the host environment, or through environment variables

## Installation

The only requirements for running this container are:

* Docker (_required_)
* Bash (_recommended_)
* SSH keys (_if applicable_)

> [!note]
> If you don't have or want to use Bash, you are advised to port the `run.sh` script to one of your liking, or run the Docker container manually.

> [!caution]
> Windows users should use WSL 2 in order to have guarantee that the environment functions as intended.

All you need to do to get started is copy the `run.sh` script somewhere you like and make it executable.

For example:

```sh
$ wget https://raw.githubusercontent.com/Netbeheer-Nederland/env/refs/tags/v1.3.1/run.sh -O ~/.local/bin/run-nbnl-env
--2025-05-08 15:23:35--  https://raw.githubusercontent.com/Netbeheer-Nederland/env/refs/tags/v1.1.0/run.sh
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 2606:50c0:8001::154, 2606:50c0:8003::154, 2606:50c0:8002::154, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|2606:50c0:8001::154|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 631 [text/plain]
Saving to: ‘/home/bart/.local/bin/run-nbnl-env’

/home/bart/.local/bin/ 100%[==========================>]     631  --.-KB/s    in 0s

2025-05-08 15:23:36 (33.1 MB/s) - ‘/home/bart/.local/bin/run-nbnl-env’ saved [631/631]

$ ls -la ~/.local/bin/run-nbnl-env
-rw-rw-r-- 1 bart bart 963 May  8 20:40 /home/bart/.local/bin/run-nbnl-env
$ chmod +x ~/.local/bin/run-nbnl-env
$ ls -la ~/.local/bin/run-nbnl-env
-rwxrwxr-x 1 bart bart 963 May  8 20:40 /home/bart/.local/bin/run-nbnl-env
```

This would enable instantiating a Docker container by simply invoking: `run-nbnl-env`.

## Running

Just run the runner script you installed earlier. If you have Git installed and set up in the host environment, the script will map your Git user to the one used in the container.

For example:

```sh
$ run-nbnl-env
```

Running the script without any arguments will assume the current working directory is the project directory, which it mounts under `/project`.

If a directory path is passed as an argument, it is used as the project directory instead. **Caution**: the provided path must be absolute. For example:

```sh
$ run-nbnl-env ~/projects/my-data-product
```

If you do not have Git set up, you must provide your user name and e-mail through environment variables:

```sh
$ GIT_USER_NAME="Your Name" GIT_USER_EMAIL="you@yourcompany.com" run-nbnl-env
```

> [!note]
> Passing in these variables takes precedence over a found Git configuration on the host environment.

## Developing

The Docker image is published on Docker Hub [here](https://hub.docker.com/r/bartkl/nbnl-env/).

### Building

Simply run the `build.sh` script:

```sh
$ ./build.sh
```

### Pushing to Docker Hub

First, tag the latest local image:

```sh
$ docker tag nbnl-env bartkl/nbnl-env:latest
```

Then, push it:

```sh
$ docker push bartkl/nbnl-env:latest
```
