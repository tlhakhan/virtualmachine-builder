package builder

import (
  "flag"
	"os/exec"
)

var packerPath string

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
