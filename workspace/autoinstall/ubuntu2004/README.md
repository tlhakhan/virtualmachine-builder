# README
- The `meta-data` and `user-data` are used by the nocloud-net provider for `cloud-init`.
- The `meta-data` is empty, but is needed by during the scanning process.
- The `user-data` contains the new `autoinstall` script that Ubuntu 20.04 uses.
  - https://wiki.ubuntu.com/FoundationsTeam/AutomatedServerInstalls#Automated_Server_Installs_for_20.04
  - https://wiki.ubuntu.com/FoundationsTeam/AutomatedServerInstalls/ConfigReference

- The ubuntu2004.ipxe script kicks off the LiveServer ISO file in a controlled way and gets the cloud-init working.
