# scibuilder-actions

These actions are designed to help with the creation of CI/CD pipelines
for the installation of scientific software.

The following actions are currently supported:

- [spack-env-build](./actions/spack-env-build/action.yml) - Installs spack environment. To use compilers from another environment, see instructions below.

All actions are described in detail below.

## spack-env-build

This action has the following required input variables:

- `system-compiler`: Name of the system compiler in spack (e.g. `gcc@11.3.1`). This will be added to the environment's `compilers`-configuration before building the environment.
- `environment`: Environment to build.

There are also these optional input variables:

- `spack-repository`: Spack repository to use. Will be cloned into  `/spack` if it is not yet present. Default: spack's official repository.
- `spack-version`: Spack version to use. This tag / branch will be checked out. Default: develop.
- `compiler-paths`: Paths that will be searched for compilers before installing the environment. Compilers that are found will be added to the environment's `compilers`-configuration. Whitespace delimited list.
- `compiler-names`: Name of the compiler in spack (e.g. `gcc@11.3.0` or `oneapi@2023.1.0`) to install before installing rest of the environment. Whitespace delimited list.
- `compiler-packages`: Name of the compiler package in spack (e.g. `gcc@11.3.0` or `intel-oneapi-compilers@2023.1.0`) to install before installing rest of the environment. Whitespace delimited list. Must have equal length to `compiler-names`
- `customizations`: Optional customizations file to spack environments. See customizations section for more information.
