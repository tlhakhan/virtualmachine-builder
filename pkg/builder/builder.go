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

	// perform the packer inspect command
	out, err := exec.Command(packerPath, packerArgs...).Output()
	if err != nil {
		return nil, err
	}

	// create the map to store the kv pairs
	var p = make(PackerVars)
	scanner := bufio.NewScanner(bytes.NewReader(out))

	for scanner.Scan() {
		// the useful message is the last string after split on ,
		line := strings.Split(scanner.Text(), ",")
		message := line[len(line)-1]

		// search for input variables or local variables
		if strings.HasPrefix(message, "> input-variables:") || strings.HasPrefix(message, "> local-variables:") {
			// the "message" is an escaped string, so convert newlines into real newlines
			message = strings.Replace(message, `\n`, "\n", -1)

			// run through another scanner
			kvScanner := bufio.NewScanner(strings.NewReader(message))
			for kvScanner.Scan() {
				kv := kvScanner.Text()

				// if the kv text starts with var or local, we want that in our value bag
				if strings.HasPrefix(kv, "var.") || strings.HasPrefix(kv, "local.") {
					pair := strings.Split(kv, ":")
					// strip out var. or local. on the key name
					key := strings.TrimPrefix(pair[0], "var.")
					key = strings.TrimPrefix(key, "local.")
					// get the value, remove double quotes and remove whitespaces
					value := strings.TrimSpace(strings.Replace(pair[1], `"`, "", -1))
					// store kv in value bag map
					p[key] = value
				}
			}
		}
	}

	// successfully extracted all packer variables
	return p, nil
}
