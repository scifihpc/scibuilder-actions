# scibuilder-actions

These actions are designed to help with the creation of CI/CD pipelines
for the installation of scientific software.

The following actions are currently supported:

- [spack-env-build](./actions/spack-env-build/action.yml) - Installs spack
  environments. To use compilers from another environment, see instructions
  below.
- [mamba-env-build](./actions/mamba-env-build/action.yml) - Installs conda
  environments with
  [micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html).

All actions are described in detail below.

## spack-env-build

This action has the following required input variables:

- `system-compiler`: Name of the system compiler in spack (e.g. `gcc@11.3.1`).
  This will be added to the environment's `compilers`-configuration before
  building the environment.
- `environment`: Environment to build.

There are also these optional input variables:

- `spack-repository`: Spack repository to use. Will be cloned into  `/spack`
- if it is not yet present. Default: spack's official repository.
- `spack-version`: Spack version to use. This tag / branch will be checked out.
  Default: develop.
- `compiler-paths`: Paths that will be searched for compilers before installing
  the environment. Compilers that are found will be added to the environment's
  `compilers`-configuration. Whitespace delimited list.
- `compiler-names`: Name of the compiler in spack (e.g. `gcc@11.3.0` or
  `oneapi@2023.1.0`) to install before installing rest of the environment.
  Whitespace delimited list.
- `compiler-packages`: Name of the compiler package in spack (e.g. `gcc@11.3.0`
  or `intel-oneapi-compilers@2023.1.0`) to install before installing rest of
  the environment. Whitespace delimited list. Must have equal length to
  `compiler-names`
- `env-vars`: Optional environment variables set during build process
  (e.g. `SPACK_CUSTOMIZATIONS=./rocky9.yaml`). Can be used to include
  branch / site specific customizations to spack environments.
- `makefile-build`: Use Spack's Makefile for parallel building (experimental).
- `buildcache-install`: Only install from buildcache. Useful for deploying software.
- `njobs`: Number of jobs for building. Default is 16.
- `ulimit`: Number of files that can be opened. Set by ulimit. Default is 65536.

### Using spack-env-build in a workflow

An example workflow is provided in
[here](example_workflows/spack-single-env/workflow.yml).

Typically, the action looks something like this:

```yml
  - uses: scifihpc/scibuilder-actions/actions/spack-env-build@v0.1.0
    with:
      spack-version: v0.20.1
      environment: "$GITHUB_WORKSPACE/my-spack-environment-folder"
      customizations: "my-site-specific-customizations.yml"
      system-compiler: gcc@11.3.1
      os: rocky9
```

## mamba-env-build

- `install-folder`: Folder where environments should be installed.
- `module-folder`: Folder where Lmod module files should be installed.
- `environments-folder`: Folder that contains the environment .yml-files that
- the actions should build.
- `hash-length`: Number of characters from the environment hash that are used
- in the installation folder name. Default is `7`.
- `version-separator`: Character that separates the name of the module from
- the version in the environment's name-field. Default is `'_'`.
- `micromamba`: Micromamba download URL.
- Default is https://micro.mamba.pm/api/micromamba/linux-64/latest
- `cuda-override`: Value of CONDA_OVERRIDE_CUDA. Default is `12.1`.
- `lmod-dir`: Directory where Lmod is installed. Set to LMOD_DIR in
- interactive shells. This is used when testing for any problems in custom
- module files Default is `/usr/share/lmod/lmod/libexec`.
- `lmod-replace-name`: String that will be replaced with the name in custom
- modules
- `lmod-replace-version`: String that will be replaced with the version in
- custom modules
- `lmod-replace-prefix`: String that will be replaced with the installation
- prefix in custom modules

### Using mamba-env-build in a workflow

An example workflow is provided in
[here](example_workflows/mamba-single-env/workflow.yml).

Typically, the action looks something like this:

```yml
    - uses: ./actions/mamba-env-build
      with:
        install-folder: "/appl/mamba/software"
        module-folder: "/appl/mamba/modules"
        environments-folder: "$GITHUB_WORKSPACE/example_workflows/mamba-single-env/environments"
```

## Development setup

A developer setup is described in [this document](dev/development-setup.md).
It allows you to test workflows locally with
[act](https://github.com/nektos/act).
