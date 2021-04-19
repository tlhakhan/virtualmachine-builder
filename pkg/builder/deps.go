package builder

import (
	"log"
	"os"
	"os/exec"
)

// path where packer should be
// discovered by performing a package install
const packerPath = "/usr/bin/packer"

// openssl needed to generate password crypt
const opensslPath = "/usr/bin/openssl"

// init is called on library initialization
func init() {

	// check if packer exists
	{
		_, err := os.ReadFile(packerPath)
		if err != nil {
			log.Printf("%s not found", packerPath)
			log.Fatalln(err)
		}

		// try the packer binary by getting its version
		{
			cmd := exec.Command(packerPath, "version")
			cmdString := getCommandString(cmd)

			stdout, err := cmd.StdoutPipe()
			if err != nil {
				log.Fatalln(err)
			}

			stderr, err := cmd.StderrPipe()
			if err != nil {
				log.Fatalln(err)
			}

			cmd.Start()
			<-logPipe(stdout, "%s out", cmdString)
			<-logPipe(stderr, "%s err", cmdString)
		}
	}

	// check if openssl exists
	{
		_, err := os.ReadFile(opensslPath)
		if err != nil {
			log.Printf("%s binary was not found", opensslPath)
			log.Fatalf("error message: %s", err)
		}

		// try the openssl binary by getting its version
		{
			cmd := exec.Command(opensslPath, "version")
			cmdString := getCommandString(cmd)

			stdout, err := cmd.StdoutPipe()
			if err != nil {
				log.Fatalln(err)
			}

			stderr, err := cmd.StderrPipe()
			if err != nil {
				log.Fatalln(err)
			}

			cmd.Start()
			<-logPipe(stdout, "%s out", cmdString)
			<-logPipe(stderr, "%s err", cmdString)
		}
	}
}
