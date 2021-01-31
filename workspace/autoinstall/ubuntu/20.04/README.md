# README
- The `meta-data` and `user-data` are used by the nocloud-net provider in `cloud-init`.
- The `meta-data` is empty, but is needed by during the scanning process. If this file doesn't exist, it stops the cloud-init process.
- The `user-data` contains the *autoinstall* script that Ubuntu 20.04 uses.
- The `20.04.ipxe` is the launch script.
