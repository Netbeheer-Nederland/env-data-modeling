# Environment

Netbeheer Nederland environment for information modeling and generating documentation and schemas.

## Features

When using Dev Containers, the benefits are maximal:

* Fully installed and configured environment for working on projects such as information models, application profiles and documentation.
* VS Code with useful extensions pre-installed and recommended settings set.
* Developer experience working in Dev Container as if working locally:
    * Local Git configuration (if present) is mapped to the container;
    * Project files are mounted in the container;
    * Commands run in the terminal will run in the container and therefore run in the desired environment;
    * IDE commands and interactions all work within the container.

## Requirements

* Docker
* VS Code (recommended for Dev Containers)

> [!note]
> Windows users need to have an up to date version of WSL installed as well.

## Usage

### Dev Container

The `.devcontainer.json` contains a specification for creating a Dev Container which takes care of setting up the uniform environment specified in the Docker image, but also providing a seamless editing experience in that container as if one were wokring locally. The file tree, terminal, Git interactions, etc. are all run in the container, even though the experience is no different from working on a local project.

> [!note]
> There are other IDEs with support for the Dev Container specification, including IntelliJ IDEs and Vim. Use these plugins at your own risk.

There are two ways a developer can set up the use of Dev Containers:

1. Specify a Dev Container per repository; or
2. Work with one Dev Container for all repositories.

There are pros and cons to each approach, but (2) is currently recommended because then it is trivial to mount multiple repositories in a single environment, which is necessary for tasks across projects such as documentation site generation and the creation of a new project using command-line scripts.

To set up the Dev Container, simply copy the `.devcontainer.json` file from this repository to either your repository root if you wish to go with option (1), or the root of where your IDE manages all its repositories if you wish to go with option (2).

### Docker container

Using the Docker container provides you with a uniform environment, but unlike the Dev Container will not enhance your IDE with preconfigured settings and extensions.

The Docker container is published on GHCR and can be found [here](https://github.com/Netbeheer-Nederland/env/pkgs/container/env).

### Own environment

> [!warning]
> Managing one's own environment this way makes it virtually impossible to guarantee environment uniformity. Only go this route if you are a developer and know what you are doing. Even then, proceed with great caution.

It is also possible to not make use of any container and just stick to one's own editor, setups and tools.

In this scenario, the user themselve is responsible for ensuring the environment they work in is valid. At the very least this involves using package managers to install dependencies declared in files such as `package.json` and `pyproject.toml`, but it is also wise to read through the `Dockerfile` of this environment and try to replicate as closely as possible what is installed and configured there.


## Developing


### Building and tagging

Increment the version to the newest `vX.Y` and build using:

```sh
$ docker build \
    --tag ghcr.io/netbeheer-nederland/env:vX.Y \
    --tag ghcr.io/netbeheer-nederland/env:latest \
    .
```

### Pushing

Push to GHCR using:

```sh
$ docker push --all-tags ghcr.io/netbeheer-nederland/env
```
