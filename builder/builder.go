package builder

import(
  "bufio"
  "os"
  "os/exec"
  "embed"
  "fmt"
  "gopkg.in/yaml.v3"
  "io/ioutil"
  "log"
)

// path where packer should be
// discovered by performing a package install
const packerPath = "/usr/bin/packer"

//go:embed installer_templates
var templates embed.FS

// struct for build env file
type config struct {
  BuildHost buildHost `yaml:"build"`
  VirtualMachine virtualMachine `yaml:"vm"`
  Blob blob `yaml:"blob"`
}

type buildHost struct {
  Server string `yaml:"server"`
  User string `yaml:"user"`
  Password string `yaml:"password"`
  Network string `yaml:"network"`
  Datastore string `yaml:"datastore"`
}

type virtualMachine struct {
  User string `yaml:"user"`
  Password string `yaml:"password"`
  Name string
  OperatingSystem string
  OperatingSystemVersion string
}

type blob struct {
  DirPath string `yaml:"dir"`
}

type Builder struct {
  *config
  HTTPAddr string
}

// init is called on library initialization
// check if packer exists
func init() {
  // check if packer exists
  _, err := os.ReadFile(packerPath)
  if err != nil {
    log.Printf("%s binary was not found", packerPath)
    log.Fatalf("error message: %s", err)
  }

  // try the packer binary by getting its version
  out, err := exec.Command(packerPath, "version").CombinedOutput()
  if err != nil {
    log.Printf("unable to get packer version")
    log.Fatalf("error message: %s", err)
  }
  log.Printf("packer version: %s", out)
}

// New creates a builder type
func New(configFilePath, virtualMachineName, operatingSystem, operatingSystemVersion string) *Builder{

  // parse the given config at file path
  c, err := parseConfigFile(configFilePath)
  if err != nil {
    log.Printf("unable to parse config file [ %s ]", configFilePath)
    log.Fatalf("error message: %s", err)
  }

  // validate the config 
  if err = validateConfig(c); err != nil {
    log.Printf("unable to parse config file [ %s ]", configFilePath)
    log.Fatalf("error message: %s", err)
  }

  // create builder type
  b := Builder{
    config: c,
    HTTPAddr: "0.0.0.0:0",
  }

  // attach the vm details
  b.VirtualMachine.Name = virtualMachineName
  b.VirtualMachine.OperatingSystem = operatingSystem
  b.VirtualMachine.OperatingSystemVersion = operatingSystemVersion

  return &b
}

// parseConfigFile parses a given file path as a yaml file that contains the required config variables to proceed with build.
func parseConfigFile(configFilePath string) (*config, error) {
  var c config
  yamlFile, err := ioutil.ReadFile(configFilePath)
  if err != nil {
    // file read error
    log.Printf("unable to read config file [ %s ]", configFilePath)
    return nil, err
  }
  err = yaml.Unmarshal(yamlFile, &c)
  if err != nil {
    // yaml can't be parsed
    log.Printf("error on parsing yaml file [ %s ]", configFilePath)
    return nil, err
  }
  return &c, nil
}

// validateConfig will validate the given config struct, it will return (true, nil) upon success or (false, error) on failure.
func validateConfig(c *config) error {
  return nil
}

// getPackerEnv return a string array of key=val environment variables for packer command
func (b *Builder) getPackerEnv() []string {
  return []string {
    fmt.Sprintf("BUILD_SERVER=%s", b.BuildHost.Server),
    fmt.Sprintf("BUILD_NETWORK=%s", b.BuildHost.Network),
    fmt.Sprintf("BUILD_DATASTORE=%s", b.BuildHost.Datastore),
    fmt.Sprintf("BUILD_USER=%s", b.BuildHost.User),
    fmt.Sprintf("BUILD_PASSWORD=%s", b.BuildHost.Password),
    fmt.Sprintf("VM_NAME=%s", b.VirtualMachine.Name),
    fmt.Sprintf("VM_USER=%s", b.VirtualMachine.User),
    fmt.Sprintf("VM_PASSWORD=%s", b.VirtualMachine.Password),
    fmt.Sprintf("HTTP_ADDR=%s", b.HTTPAddr),
    "PATH=/usr/bin",
  }
}

// Build will build the requested virtual machine to completion.
func (b *Builder) Build() {

  // start up the http server needed by the build process
  // send installer_templates embed.FS to it
  b.launchHTTPServer(templates)

 // retrieve packer template file from the embedded filesystem
  packerTemplatePath := fmt.Sprintf("installer_templates/%s/%s/packer_template.json", b.VirtualMachine.OperatingSystem, b.VirtualMachine.OperatingSystemVersion)
  packerTemplate, err := templates.ReadFile(packerTemplatePath)
  if err != nil {
    log.Printf("unable to read packer template file for [ %s/%s ]", b.VirtualMachine.OperatingSystem, b.VirtualMachine.OperatingSystemVersion)
    log.Fatalf("error message: %s", err)
  }

  // validate packer template
  if err := b.validatePackerTemplate(packerTemplate); err != nil {
    log.Println("failed to validate packer template")
    log.Fatalf("error message: %s", err)
  }

  // build packer template
  if err := b.buildPackerTemplate(packerTemplate); err != nil {
    log.Println("failed to build packer template")
    log.Fatalf("error message: %s", err)
  }

  // Work is done
  return
}

// validatePackerTemplate
func (b *Builder) validatePackerTemplate(packerTemplate []byte) error {

  // form the command
  cmd := exec.Command(packerPath, "validate", "-")
  // setup the enviroment
  cmd.Env = b.getPackerEnv()

  // create the stdin pipe to the command
  stdin, err := cmd.StdinPipe()
  if err != nil {
    log.Printf("unable to create stdin pipe")
    return err
  }

  // in a separate go routine feed the template as stdin into the command
  go func() {
    defer stdin.Close()
    fmt.Fprintf(stdin, string(packerTemplate))
  }()

  // run the command
  out, err := cmd.CombinedOutput()
  if err != nil {
    // if return code isn't 0, then we have some sort of error.
    // likely a template parsing error, else related to the command
    log.Printf("error message: %s", out)
    return err
  }

  return nil
}

func (b *Builder) buildPackerTemplate(packerTemplate []byte) error {

    // form the command
  cmd := exec.Command(packerPath, "build", "-")

  // setup the enviroment
  cmd.Env = b.getPackerEnv()

  // create the stdin pipe to the command
  stdin, err := cmd.StdinPipe()
  if err != nil {
    log.Printf("unable to create stdin pipe")
    return err
  }

  // in a separate go routine feed the template as stdin into the command
  go func() {
    defer stdin.Close()
    fmt.Fprintf(stdin, string(packerTemplate))
  }()

  // setup stderr and stdout
  stdout, err := cmd.StdoutPipe()
  if err != nil {
    log.Printf("unable to create stdout pipe")
    return err
  }

  stderr, err := cmd.StderrPipe()
  if err != nil {
    log.Print("unable to create stderr pipe")
    return err
  }

  // capture stdout to log
  go func() {
    defer stdout.Close()
    in := bufio.NewScanner(stdout)
    for in.Scan() {
      log.Printf("packer output: %s", in.Text())
    }
  }()

  // capture stderr to log
  go func() {
    defer stderr.Close()
    in := bufio.NewScanner(stderr)
    for in.Scan() {
      log.Printf("packer error: %s", in.Text())
    }
  }()

/*
  cmdDone := make(chan bool, 1)
*/
  // run the command
  if err = cmd.Run(); err != nil {
    // if return code isn't 0, then we have some sort of error.
    // likely a template parsing error, else related to the command
    return err
  }
/*
  cmdDone<-true


  // wait for interrupt or wait for command to finish
  select {
    case <-ctx.Done():
      log.Println("sent os interrupt to command")
      cmd.Process.Signal(os.Interrupt)
    case <-cmdDone:
      return nil
   }
*/
  return nil
}
