package main

import (
	"flag"
	"fmt"
	"github.com/tenzin-io/vm-builder/pkg/builder"
	"os"
	"os/signal"
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
	version                bool
	configFilePath         string
	virtualMachineName     string
	operatingSystem        string
	operatingSystemRelease string
)

func init() {
	// parse flags
	flag.StringVar(&configFilePath, "c", "", "Config file path.")
	flag.StringVar(&virtualMachineName, "n", "", "Virtual machine name.")
	flag.StringVar(&operatingSystem, "o", "", "Operating system.")
	flag.StringVar(&operatingSystemRelease, "r", "", "Operating system release name.")
	flag.BoolVar(&version, "version", false, "Print program version.")
}

func main() {

	flag.Parse()

	if version {
		showVersion()
		os.Exit(0)
	}

	// validate
	if configFilePath == "" ||
		virtualMachineName == "" ||
		operatingSystem == "" ||
		operatingSystemRelease == "" {
		flag.Usage()
		os.Exit(1)
	}

	// this command needs to ignore/mask os.Interrupt
	// packer will get the interrupt signal passed down and gracefully halt
	signal.Ignore(os.Interrupt)

	// create a builder instance
	b := builder.New(configFilePath, virtualMachineName, operatingSystem, operatingSystemRelease)

	// perform build
	b.Build()
}

// showVersion prints the version that is starting.
func showVersion() {
	fmt.Print(versionString())
	fmt.Print(releaseString())
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
