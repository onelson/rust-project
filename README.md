The docker-compose config included in the repo, along with some
supporting scripts should help bootstrap a development environment.


# How to use

From a fresh clone, run:

```
$ ./setup.sh
...
```

The containers are created using _the current user's_ **uid** and
**gid** so be sure to run this as you (not root). This is critical
to making files generated inside the containers have the correct
ownership.

# Develop

The provided `docker-compose.yml` is geared towards developing rust programs 
that may require native dependencies, allowing those deps to be explicitly 
stated (by the Dockerfile).

The compose config manages a data volume for the `CARGO_HOME` so you can 
install deps and tools as needed and they will be preserved from run to run.

If you need to wipe your container clean, use `docker-compose down --volumes`
then re-run `./setup.sh` to rebuild your image.

Your development will happen inside the container, and as such you may like
to use the `./run.sh` script as a shorthand way to execute commands. For 
example:

```
$ ./run.sh cargo check
...
```

The build in the `dev` image is dynamicly linked and as such, native deps can 
be installed via `apt-get`.

# Deploy

A _deploy_ Dockerfile is included, which does a multi-phase (requiring docker 
17.05 or above) cross build, which should ultimately yield a `FROM scratch` 
image with a static build of your app.

Example:

```
$ docker build -t my-app -f dockerfiles/builder/Dockerfile .
$ docker run --rm  my-app
Hello, world!
$
```

Since this Dockerfile is producing a static binary, your native dependecies 
may need to be built from source so that they can be statically linked.

