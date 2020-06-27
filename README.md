# README
- A docker-compose project which uses a packer container to build a VM on an ESXi hypervisor.

## var-files
- There is a folder called `var-files` which should contain your VM configuration as a json file.

## Walkthrough
- Place your VM configuration json in the `var-files` folder, named after the VM.
- Run the `docker-compose run packer [ vm-name ]`.
- If no argument given, it will fail with a help message requesting a VM name.

### Output
```
tlhakhan@ah-tlhakhan-mac packer-esxi % docker-compose run packer database-80
Template validated successfully.
vmware-iso: output will be in this color.

==> vmware-iso: Retrieving ISO
==> vmware-iso: Trying http://repo.home.local/artifactory/iso_library/empty.iso
==> vmware-iso: Trying http://repo.home.local/artifactory/iso_library/empty.iso?checksum=md5%3A4b58e1ea0f4975286da9760565eeae06
empty.iso 362.00 KiB / 362.00 KiB [===========================================================] 100.00% 0s
==> vmware-iso: http://repo.home.local/artifactory/iso_library/empty.iso?checksum=md5%3A4b58e1ea0f4975286da9760565eeae06 => /packer/packer_cache/709b587426293144fc708521d6d7221d9aefb580.iso
==> vmware-iso: Remote cache was verified skipping remote upload...
==> vmware-iso: Creating required virtual machine disks
==> vmware-iso: Building and writing VMX file
==> vmware-iso: Registering remote VM...
==> vmware-iso: Starting virtual machine...
==> vmware-iso: Waiting 10s for boot...
==> vmware-iso: Connecting to VM via VNC (vs-200.home.local:5900)
==> vmware-iso: Typing the boot command over VNC...
==> vmware-iso: Waiting for SSH to become available...
==> vmware-iso: Connected to SSH!
==> vmware-iso: Provisioning with Ansible...
    vmware-iso: Uploading Playbook directory to Ansible staging directory...
    vmware-iso: Creating directory: /tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9
    vmware-iso: Uploading main Playbook file...
    vmware-iso: Uploading inventory file...
    vmware-iso: Executing Ansible: cd /tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9 && ANSIBLE_FORCE_COLOR=1 PYTHONUNBUFFERED=1 ansible-playbook /tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/centos8.yml --extra-vars "packer_build_name=vmware-iso packer_builder
_type=vmware-iso packer_http_addr= -o IdentitiesOnly=yes" -e vm_hostname=database-80 -c local -i /tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/packer-provisioner-ansible-local187994986
    vmware-iso:
    vmware-iso: PLAY [configure centos8 vm] ****************************************************
    vmware-iso:
    vmware-iso: TASK [Gathering Facts] *********************************************************
    vmware-iso: ok: [127.0.0.1]
    vmware-iso:
    vmware-iso: TASK [centos8-vm : set hostname] ***********************************************
    vmware-iso: changed: [127.0.0.1]
    vmware-iso:
    vmware-iso: TASK [centos8-vm : send ca files] **********************************************
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/home-local-ca.crt)
    vmware-iso:
    vmware-iso: RUNNING HANDLER [centos8-vm : update-ca-trust] *********************************
    vmware-iso: changed: [127.0.0.1]
    vmware-iso:
    vmware-iso: TASK [centos8-vm : update yum.repos.d folder] **********************************
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-PowerTools.repo)
    vmware-iso: ok: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-Media.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-Extras.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-CR.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-Debuginfo.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-Base.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-AppStream.repo)
    vmware-iso: ok: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-Vault.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/epel.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-fasttrack.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-centosplus.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-Sources.repo)
    vmware-iso: changed: [127.0.0.1] => (item=/tmp/packer-provisioner-ansible-local/5ef6c1da-cb41-b4b0-4825-5f441f26fbd9/roles/centos8-vm/files/yum.repos.d/CentOS-HA.repo)
    vmware-iso:
    vmware-iso: RUNNING HANDLER [centos8-vm : yum makecache] ***********************************
==> vmware-iso: [WARNING]: Consider using the yum module rather than running 'yum'.  If you
==> vmware-iso: need to use command because yum is insufficient you can add 'warn: false' to
==> vmware-iso: this command task or set 'command_warnings=False' in ansible.cfg to get rid of
    vmware-iso: changed: [127.0.0.1]
==> vmware-iso: this message.
    vmware-iso:
    vmware-iso: TASK [centos8-vm : update all packages] ****************************************
    vmware-iso: ok: [127.0.0.1]
    vmware-iso:
    vmware-iso: TASK [centos8-vm : install yum packages] ***************************************
    vmware-iso: changed: [127.0.0.1]
    vmware-iso:
    vmware-iso: TASK [centos8-vm : send default .vimrc] ****************************************
    vmware-iso: changed: [127.0.0.1]
    vmware-iso:
    vmware-iso: TASK [centos8-vm : install docker-compose] *************************************
    vmware-iso: changed: [127.0.0.1]
    vmware-iso:
    vmware-iso: PLAY RECAP *********************************************************************
    vmware-iso: 127.0.0.1                  : ok=10   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    vmware-iso:
==> vmware-iso: Gracefully halting virtual machine...
    vmware-iso: Waiting for VMware to clean up after itself...
==> vmware-iso: Deleting unnecessary VMware files...
    vmware-iso: Deleting: /vmfs/volumes/nvme2/database-80/vmware.log
==> vmware-iso: Compacting all attached virtual disks...
    vmware-iso: Compacting virtual disk 1
==> vmware-iso: Cleaning VMX prior to finishing up...
    vmware-iso: Detaching ISO from CD-ROM device ide0:0...
    vmware-iso: Disabling VNC server...
==> vmware-iso: Skipping export of virtual machine...
==> vmware-iso: Keeping virtual machine registered with ESX host (keep_registered = true)
Build 'vmware-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> vmware-iso: VM files in directory: /vmfs/volumes/nvme2/database-80
tlhakhan@ah-tlhakhan-mac packer-esxi %
```