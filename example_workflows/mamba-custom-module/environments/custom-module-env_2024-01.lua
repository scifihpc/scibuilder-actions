-- -*- lua -*-"
--
-- Module file created by scibuilder
--

whatis([[Name : __name__]])
whatis([[Version : __version__]])
help([[This is an automatically created Python environment with custom module.]])

prepend_path("PATH", "__prefix__/bin")
setenv("CONDA_PREFIX", "__prefix__")
setenv("ENV_VAR", "custom-var")
