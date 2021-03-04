package main

import (
	"flag"
	"github.com/tlhakhan/packer-esxi/builder"
	"os"
	"os/signal"
)

// required fields
var (
	configFilePath         string
	virtualMachineName     string
	operatingSystem        string
	operatingSystemVersion string
)

func main() {

	// parse flags
	flag.StringVar(&configFilePath, "c", "", "config file")
	flag.StringVar(&virtualMachineName, "n", "", "virtual machine name")
	flag.StringVar(&operatingSystem, "o", "", "operating system")
	flag.StringVar(&operatingSystemVersion, "v", "", "operating system version")
	flag.Parse()

	// validate
	if configFilePath == "" ||
		virtualMachineName == "" ||
		operatingSystem == "" ||
		operatingSystemVersion == "" {
		flag.Usage()
		os.Exit(1)
	}

	// this command needs to ignore/mask os.Interrupt
	// packer will get the interrupt signal passed down and gracefully halt
	signal.Ignore(os.Interrupt)

	// create a builder instance
	b := builder.New(configFilePath, virtualMachineName, operatingSystem, operatingSystemVersion)

	// perform build
	b.Build()
}
