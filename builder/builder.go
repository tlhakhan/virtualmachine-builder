package builder

import(
  "gopkg.in/yaml.v3"
  "io/ioutil"
  "log"
)

// struct for build env file
type envFile struct {
  BuildHost buildHost `yaml:"build_host"`
  GuestVM guestVM `yaml:"guest_vm"`
}

type buildHost struct {
  Server string `yaml:"server"`
  Username string `yaml:"username"`
  Password string `yaml:"password"`
  Network string `yaml:"network"`
  Datastore string `yaml:"datastore"`
}

type guestVM struct {
  Username string `yaml:"username"`
  Password string `yaml:"password"`
}

// parseEnvironmentFile parses a given file path as a yaml file that contains the required environment variables to proceed with build.
func parseEnvironmentFile(envFilePath string) *envFile {
  var e envFile
  yamlFile, err := ioutil.ReadFile(envFilePath)
  if err != nil {
    // file read error
    log.Printf("Unable to read environment file %q", envFilePath)
    log.Println(err)
  }
  err = yaml.Unmarshal(yamlFile, &e)
  if err != nil {
    // yaml can't be parsed
    log.Printf("Error on parsing yaml file %q", envFilePath)
    log.Println(err)
  }
  return &e
}

// validateEnvironmentFile will validate the given envFile struct, it will return (true, nil) upon success or (false, error) on failure.
func validateEnvironmentFile(e *envFile) (bool, error) {
  return true, nil
}

// Build will build the requested virtual machine to completion.
func Build(envFilePath, virtualMachineName, operatingSystem, version string) {
  log.Println("Build requested")
  return
}
