package main

import (
	"flag"
	"fmt"
	"github.com/tenzin-io/vmware-builder/pkg/builder"
	"github.com/tenzin-io/vmware-builder/pkg/templates"
	"log"
	"os"
	"os/signal"
	"path/filepath"
	"runtime"
)

const (
	appName    = "builder"
	appVersion = "1.0"
)

var (
	gitCommit string
	buildDate string
)

var (
	version                 bool
	virtualMachineName      string
	operatingSystem         string
	operatingSystemRelease  string
	overridesPackerVarsPath string
	installersDirPath       string
	packerBuildErrorAction  string
)

func init() {
	// get the binary exec path
	ex, err := os.Executable()
	if err != nil {
		log.Fatalln(err)
	}

	installersDirPath = fmt.Sprintf("%s/%s", filepath.Dir(ex), "installers")

	// parse flags
	flag.StringVar(&virtualMachineName, "n", "", "Virtual machine name. (Required)")
	flag.StringVar(&operatingSystem, "o", "", "Operating system. Examples: debian, centos, ubuntu. (Required)")
	flag.StringVar(&operatingSystemRelease, "r", "", "Operating system release name. Examples: bullseye, 8-stream, focal, jammy. (Required)")
	flag.StringVar(&overridesPackerVarsPath, "c", fmt.Sprintf("%s/overrides.pkrvars.hcl", installersDirPath), "The path to a Packer variables file that can override the default Packer variable values.")
	flag.StringVar(&packerBuildErrorAction, "e", "ask", "If the Packer build fails do: clean up, abort, ask, or run-cleanup-provisioner.")
	flag.BoolVar(&version, "version", false, "Print program version.")

}

func main() {

	flag.Parse()

	if version {
		showVersion()
		os.Exit(0)
	}

	// input guards
	if virtualMachineName == "" || operatingSystem == "" || operatingSystemRelease == "" || overridesPackerVarsPath == "" {
		flag.Usage()
		os.Exit(1)
	}

	// this binary needs to ignore/mask os.Interrupt
	// packer will get the interrupt signal passed down and gracefully halt
	// then we can exit out of main
	signal.Ignore(os.Interrupt)

	// construct the packer args
	packerArgs := []string{
		fmt.Sprintf("-var=vm_name=%s", virtualMachineName),
		fmt.Sprintf("-var=vm_linux_distro=%s", operatingSystem),
		fmt.Sprintf("-var=vm_linux_distro_release=%s", operatingSystemRelease),
		fmt.Sprintf("-var-file=%s/%s/%s/virtual_machine.pkrvars.hcl", installersDirPath, operatingSystem, operatingSystemRelease),
		fmt.Sprintf("-var-file=%s", overridesPackerVarsPath),
		"installers/packer_template.pkr.hcl",
	}

	// packer inspect
	packerInspectArgs := []string{
		"inspect",
		"-machine-readable",
	}
	packerInspectArgs = append(packerInspectArgs, packerArgs...)
	packerVars, err := builder.ExtractVars(packerInspectArgs...)
	if err != nil {
		log.Fatalln("packer inspect failed")
	}

	// get the http address
	httpAddress := templates.LaunchTemplateServer(installersDirPath, packerVars)

	// packer validate
	packerValidateArgs := []string{
		"validate",
		fmt.Sprintf("-var=http_address=%s", httpAddress),
	}
	packerValidateArgs = append(packerValidateArgs, packerArgs...)
	err = builder.Packer(packerValidateArgs...)
	if err != nil {
		log.Fatalln("packer validation failed")
	}

	// packer build
	packerBuildArgs := []string{
		"build",
		fmt.Sprintf("-on-error=%s", packerBuildErrorAction),
		fmt.Sprintf("-var=http_address=%s", httpAddress),
	}
	packerBuildArgs = append(packerBuildArgs, packerArgs...)
	err = builder.Packer(packerBuildArgs...)
	if err != nil {
		log.Fatalln("packer build failed")
	}

}

// showVersion prints the version that is starting.
func showVersion() {
	fmt.Printf("%s %s", versionString(), releaseString())
}

// versionString returns the version as a string.
func versionString() string {
	return fmt.Sprintf("%s-%s", appName, appVersion)
}

// releaseString returns the release information related to version:
// <build date> <OS>/<ARCH> <go version> <commit>
// 20220429-200556 linux/amd64 go1.8.3 a6d2d7b5
func releaseString() string {
	return fmt.Sprintf("%s %s/%s %s %s\n", buildDate, runtime.GOOS, runtime.GOARCH, runtime.Version(), gitCommit)
}
