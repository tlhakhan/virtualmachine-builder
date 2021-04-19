package builder

import (
	"embed"
	"fmt"
	"log"
	"net"
	"net/http"
	"os/exec"
	"path"
	"strings"
	"text/template"
)

// installerVars struct is a variable bag passed to a template.
type installerVars struct {
	VirtualMachineName string
	HTTPAddr           string
	GuestUser          string
	GuestPassword      string
}

// installerHandler processes requests with the path prefix /installer/ and runs against a given templateDirPath for any matching template file.
// templates - an embedded directory of installer_templates.
// templateDirPath - process requests matching against a specific templateDirPath.
// vars - is a variable bag given to the template being executed.
func (b *Builder) installerHandler(templates embed.FS, templateDirPath string, vars installerVars) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		// try to find the requested file in the installer_templates embed.FS
		tf, err := templates.ReadFile(fmt.Sprintf("%s/%s", templateDirPath, path.Base(r.URL.Path)))
		if err != nil {
			log.Printf("unable to read http_template file: %s", path.Base(r.URL.Path))
			log.Printf("error message: %s", err)
			http.Error(w, http.StatusText(400), 400)
			return
		}

		log.Printf("http server: serving request for %s", r.URL.Path)
		t, err := template.New("installer").Parse(string(tf))
		if err != nil {
			http.Error(w, http.StatusText(500), 500)
		}
		t.Execute(w, vars)
	}
}

// launchHTTPServer is the http template engine.  The HTTP server is launched on a random port.  The server process is backgrounded as a go routine.
func (b *Builder) launchHTTPServer(templates embed.FS) {
	// make an outbound connection
	conn, err := net.Dial("udp", "0.0.0.1:0")
	if err != nil {
		log.Printf("unable to find host ip")
		log.Fatalf("error message: %s", err)
	}

	// retrieve host ip address
	localIP := conn.LocalAddr().(*net.UDPAddr).IP

	// setup tcp listener
	l, err := net.Listen("tcp", fmt.Sprintf("%s:0", localIP))
	if err != nil {
		log.Println("unable to start tcp listener")
		log.Fatalf("error message: %s", err)
	}
	log.Printf("http server: %s", l.Addr().String())

	// store http addr
	b.HTTPAddr = l.Addr().String()

	// setup http server
	mux := http.NewServeMux()

	// the plain text password needs to be crypted for template use
	guestPasswordCrypted, err := generateCryptedPassword(b.VirtualMachine.Password)
	if err != nil {
		log.Println("unable to bcrypt password")
		log.Fatalf("error message: %s", err)
	}

	// setup a installerVars struct to hold variables needed for the installer template file
	vars := installerVars{
		VirtualMachineName: b.VirtualMachine.Name,
		GuestUser:          b.VirtualMachine.User,
		GuestPassword:      string(guestPasswordCrypted),
		HTTPAddr:           b.HTTPAddr,
	}

	// setup installer handler
	// installer => installer/os/version/http_templates
	templateDirPath := fmt.Sprintf("installer_templates/%s/%s/http_templates", b.VirtualMachine.OperatingSystem, b.VirtualMachine.OperatingSystemVersion)
	mux.HandleFunc("/installer/", b.installerHandler(templates, templateDirPath, vars))

	// setup blobs handler
	// blob => blob/os/version/
	blobDirPath := fmt.Sprintf("%s/%s/%s", b.Blob.DirPath, b.VirtualMachine.OperatingSystem, b.VirtualMachine.OperatingSystemVersion)
	mux.Handle("/blob/", http.StripPrefix("/blob/", http.FileServer(http.Dir(blobDirPath))))

	// setup the default route to use mux router
	http.Handle("/", mux)

	// start up http server
	go func() {
		err = http.Serve(l, nil)
		if err != nil {
			log.Println("failed to serve http")
			log.Fatalf("error message: %s", err)
		}
	}()
}

// generateCryptedPassword uses the openssl binary to determine the crypt hash, the plain text password is passed via stdin.
func generateCryptedPassword(password string) (string, error) {
	// prepare command
	cmd := exec.Command(opensslPath, "passwd", "-6", "-stdin")
	stdin, err := cmd.StdinPipe()
	if err != nil {
		log.Print("unable to open stdin to openssl")
		return "", err
	}

	// start stdin stream
	go func() {
		defer stdin.Close()
		fmt.Fprintf(stdin, password)
	}()

	// run command
	out, err := cmd.Output()
	if err != nil {
		log.Printf("failed to run openssl")
		return "", err
	}

	return strings.TrimSpace(string(out)), nil
}
