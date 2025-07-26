# Data Modeling Environment

Netbeheer Nederland environment for information modeling and generating documentation and schemas.

## Features

When using Dev Containers, the benefits are maximal:

* Fully installed and configured environment for working on schemas and application profiles.
* VS Code with useful extensions pre-installed and recommended settings set.
* Developer experience working in Dev Container as if working locally:
    * Local Git configuration is mapped to the container;
    * Project files are mounted in the container;
    * Commands run in the terminal will run in the container and therefore run in the desired environment;
    * IDE commands and interactions all work within the container.

## Requirements

* Docker
* VS Code (recommended for Dev Containers)
* Git (configured)

> [!note]
> Windows users need to have an up to date version of WSL installed as well.

## Usage

### Dev Container

The `.devcontainer.json` contains a specification for creating a Dev Container which takes care of setting up the uniform environment specified in the Docker image, but also providing a seamless editing experience in that container as if one were wokring locally. The file tree, terminal, Git interactions, etc. are all run in the container, even though the experience is no different from working on a local project.

> [!note]
> There are other IDEs with support for the Dev Container specification, including IntelliJ IDEs and Vim. Use these plugins at your own risk.

### Docker container

Using the Docker container provides you with a uniform environment, but unlike the Dev Container will not enhance your IDE with preconfigured settings and extensions.

The Docker container is published on GHCR and can be found [here](https://github.com/Netbeheer-Nederland/env-data-modeling/pkgs/container/env-data-modeling).

### Own environment

> [!warning]
> Managing one's own environment this way makes it virtually impossible to guarantee environment uniformity. Only go this route if you are a developer and know what you are doing. Even then, proceed with great caution.

It is also possible to not make use of any container and just stick to one's own editor, setups and tools.

In this scenario, the user themselves is responsible for ensuring the environment they work in is valid. At the very least this involves using package managers to install dependencies declared in files such as `package.json` and `pyproject.toml`, but it is also wise to read through the `Dockerfile` of this environment and try to replicate as closely as possible what is installed and configured there.


## Developing


### Building and tagging

Increment the version to the newest `vX.Y` and build using:

```sh
$ docker build \
    --tag ghcr.io/netbeheer-nederland/env-data-modeling:vX.Y \
    --tag ghcr.io/netbeheer-nederland/env-data-modeling:latest \
    .
```

### Pushing

Push to GHCR using:

```sh
$ docker push --all-tags ghcr.io/netbeheer-nederland/env-data-modeling
```
