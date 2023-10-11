# Setting up a development workflow

## Running the example action with rootless podman

1. Install podman and set up the
   [rootless environment](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)
2. Create a local folder to a local disk (for example `/l/$USER/scibuilder`)
3. Configure podman to use local storage by setting the following in the following
   file `~/.config/containers/storage.conf`:

   ```ini
   [storage]
   driver = "overlay"
   graphroot = "/l/$USER/podman/storage"
   ```

4. Create the storage folder:
   `mkdir -p /l/$USER/podman/storage`
5. Clone this repository:
   `git clone https://github.com/scifihpc/scibuilder-actions.git`
6. Install act:

    ```sh
    mkdir bin
    ACT_VERSION=v0.2.51
    wget -q -O - https://github.com/nektos/act/releases/download/$ACT_VERSION/act_Linux_x86_64.tar.gz | tar -xz -C bin
    ```

7. Test running the builder with this:

    ```sh
    export PATH=$PATH:$PWD/bin
    bash dev/run-workflow.sh example_workflows/spack-single-env/workflow.yml
    ```

## Running the example action with docker (not recommended)

Rootless podman is recommended over docker. Running the builds without
root makes using the end products easier as they are owned by the build
user instead of root.

In addition, running the builds as a build user reduces any possible
security problems.

1. Install docker
2. Clone this repository:
   `git clone https://github.com/scifihpc/scibuilder-actions.git`
3. Test running the builder with this:

    ```sh
    export PATH=$PATH:$PWD/bin
    bash dev/run-workflow.sh --docker example_workflows/spack-single-env/workflow.yml
    ```

## Viewing the applications

Once the build finishes, you can enter the container and view the installed
applications.

With `podman` the command to launch the container is

```sh
podman run -v buildcache:/buildcache -v spack-single-env-envs:/appl -i -t docker.io/aaltoscienceit/scibuilder-actions:rocky9 bash -l
```

When using `docker` just switch `podman` to `docker`.

This will give a terminal in the container. Applications have been installed to
`/appl/scibuilder-spack/rocky9/single-env`.

To load e.g. `hdf5`-module, one can run

```sh
module use /appl/scibuilder-spack/rocky9/single-env/lmod/linux-rocky9-x86_64/Core/
module load openmpi hdf5
h5pcc --help
```

All of the installed applications are also sent to a
[build cache](https://spack.readthedocs.io/en/latest/binary_caches.html)
in `/buildcache`. You can view the packages with:

```sh
ls /buildcache/final/build_cache
```
