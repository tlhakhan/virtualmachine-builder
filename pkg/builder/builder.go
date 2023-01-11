package builder

import (
	"bufio"
	"bytes"
	"flag"
	"os/exec"
	"strings"
)

var packerPath string

type PackerVars map[string]string

func init() {
	flag.StringVar(&packerPath, "packer-path", "/usr/local/bin/packer", "The path to the Hashicorp Packer binary.")
}

// Packer command
func Packer(packerArgs ...string) error {

	cmd := exec.Command(packerPath, packerArgs...)
	cmdString := getCommandString(cmd)

	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return err
	}

	stderr, err := cmd.StderrPipe()
	if err != nil {
		return err
	}

	err = cmd.Start()
	if err != nil {
		return err
	}

	// read the stdout and stderr pipes
	<-logPipe(stdout, "%s out", cmdString)
	<-logPipe(stderr, "%s err", cmdString)

	err = cmd.Wait()
	if err != nil {
		return err
	}

	return nil
}

// Packer
func ExtractVars(packerArgs ...string) (PackerVars, error) {
	out, err := exec.Command(packerPath, packerArgs...).Output()
	if err != nil {
		return nil, err
	}

	/*
	   1673406288,,ui,say,Packer Inspect: HCL2 mode\n
	   1673406288,,ui,say,> input-variables:\n\nvar.esx_datastore: "datastore1"\nvar.esx_network: "VM Network"\nvar.esx_password: "password"\nvar.esx_server: "vsphere-1"\nvar.esx_username: "builder"\nvar.http_address: "127.0.0.1"\nvar.ssh_keys_url: "<unknown>"\nvar.vm_cpus: "2"\nvar.vm_disk_adapter_type: "nvme"\nvar.vm_disk_size: "10240"\nvar.vm_guest_os_type: "otherlinux-64"\nvar.vm_linux_distro: "Linux"\nvar.vm_linux_distro_release: "Generic"\nvar.vm_memory: "1024"\nvar.vm_name: "machine-00"\nvar.vm_password: "password"\nvar.vm_shutdown_command: "sudo poweroff"\nvar.vm_username: "sysuser"\nvar.vm_version: "19"\n\n> local-variables:\n\n
	   1673406288,,ui,say,> builds:\n\n  > <unnamed build 0>:\n\n    sources:\n\n      vmware-iso.virtual_machine\n\n    provisioners:\n\n      <no provisioner>\n\n    post-processors:\n\n      <no post-processor>\n
	*/
	var p = make(PackerVars)
	scanner := bufio.NewScanner(bytes.NewReader(out))
	for scanner.Scan() {
		line := strings.Split(scanner.Text(), ",")
		message := line[len(line)-1]
		if strings.HasPrefix(message, "> input-variables:") || strings.HasPrefix(message, "> local-variables:") {
			message = strings.Replace(message, `\n`, "\n", -1)
			kvScanner := bufio.NewScanner(strings.NewReader(message))
			for kvScanner.Scan() {
				kv := kvScanner.Text()
				if strings.HasPrefix(kv, "var.") || strings.HasPrefix(kv, "local.") {
					pair := strings.Split(kv, ":")
					key := strings.TrimPrefix(pair[0], "var.")
					key = strings.TrimPrefix(key, "local.")
					value := strings.TrimSpace(strings.Replace(pair[1], `"`, "", -1))
					p[key] = value
				}
			}
		}
	}
	return p, nil
}
