# README
This is the httpdir folder, it is referenced by packer templates' `http_directory` variable.

filename | description
--- | ---
`mount_iso_folders.sh` | Finds iso files, makes a folder called `iso` in the same directory, and mounts the iso file to it.
`unmount_iso_folders.sh` | Finds any iso folder and unmounts it.

## Get ISO files
Each of `os/version` folder contains documentation to help retrieve the required files.  Any `*.iso` files or `iso` folders are git ignored by default.

## Mounting ISO folders
Run the `mount_iso_folders.sh` script, it finds all ISO files and mounts them to a path local `iso` folder. 

## Writing iPXE scripts
The variables `http_ip` and `http_port` are initialized by packer template and avalable to the next chained iPXE script.
