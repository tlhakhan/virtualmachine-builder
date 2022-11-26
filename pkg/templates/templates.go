package templates

import (
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"os/exec"
	"path"
	"strings"
	"text/template"
)

var openSSLPath string

func init() {
	flag.StringVar(&openSSLPath, "openssl-path", "/usr/bin/openssl", "The path to the OpenSSL binary.")
}

// installerVars struct is a variable bag passed to a template.
type templateVars struct {
	VirtualMachineName string
	GuestUserName      string
	GuestPassword      string
	HTTPAddress        string
}

func templatesHandler(templateDirPath string, vars templateVars) func(http.ResponseWriter, *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		// try to find the file
		templateName := path.Base(r.URL.Path)
		templateFilePath := fmt.Sprintf("%s/%s", templateDirPath, templateName)

		// try to open the template file
		tf, err := os.Open(templateFilePath)
		if err != nil {
			log.Printf("unable to open template file: %s", templateFilePath)
			log.Printf("error message: %s", err)
			http.Error(w, http.StatusText(400), 400)
			return
		}

		// read the template file contents
		tc, err := io.ReadAll(tf)
		if err != nil {
			log.Printf("unable to read template file: %s", templateFilePath)
			log.Printf("error message: %s", err)
			http.Error(w, http.StatusText(400), 400)
			return
		}

		t, err := template.New(templateName).Parse(string(tc))
		if err != nil {
			log.Printf("unable to parse template file: %s", templateFilePath)
			log.Printf("error message: %s", err)
			http.Error(w, http.StatusText(500), 500)
			return
		}
		log.Printf("http server: serving request for %s using %s", templateName, templateFilePath)
		t.Execute(w, vars)
	}
}

func LaunchTemplateServer(installersDirPath string, operatingSystem string, operatingSystemRelease string, virtualMachineName string, virtualMachineUserName string, virtualMachinePassword string) string {

	// make an outbound connection
	conn, err := net.Dial("udp", "1.1.1.1:53")
	if err != nil {
		log.Printf("unable to find host ip")
		log.Fatalf("error message: %s", err)
	}

	// retrieve host ip address
	localIP := conn.LocalAddr().(*net.UDPAddr).IP

	// setup tcp listener for http listen
	listener, err := net.Listen("tcp", fmt.Sprintf("%s:0", localIP))
	if err != nil {
		log.Println("unable to start tcp listener")
		log.Fatalf("error message: %s", err)
	}

	log.Printf("template http server: %s", listener.Addr().String())

	// setup http mux
	mux := http.NewServeMux()

	// the plain text password needs to be crypted for template use
	guestPasswordCrypted, err := generateCryptedPassword(virtualMachinePassword)
	if err != nil {
		log.Println("unable to bcrypt password")
		log.Fatalf("error message: %s", err)
	}

	// templateVars to give to the templates
	tv := templateVars{
		VirtualMachineName: virtualMachineName,
		GuestUserName:      virtualMachineUserName,
		GuestPassword:      string(guestPasswordCrypted),
		HTTPAddress:        listener.Addr().String(),
	}

	// setup the templates path
	templatesDirPath := fmt.Sprintf("%s/%s/%s/templates", installersDirPath, operatingSystem, operatingSystemRelease)
	mux.HandleFunc("/templates/", templatesHandler(templatesDirPath, tv))

	// setup the files path
	filesDirPath := fmt.Sprintf("%s/%s/%s/files", installersDirPath, operatingSystem, operatingSystemRelease)
	mux.Handle("/files/", http.StripPrefix("/files/", http.FileServer(http.Dir(filesDirPath))))

	// give the mux to handle the root path
	http.Handle("/", mux)

	// start up template http server
	go func() {
		err = http.Serve(listener, nil)
		if err != nil {
			log.Println("failed to serve http")
			log.Fatalf("error message: %s", err)
		}
	}()

	// return the HTTP address for use by packer
	return tv.HTTPAddress

}

// launchHTTPServer is the http template engine.  The HTTP server is launched on a random port.  The server process is backgrounded as a go routine.
// func (b *Builder) launchHTTPServer(templates embed.FS) {
// 	// make an outbound connection
// 	conn, err := net.Dial("udp", "8.8.8.8:53")
// 	if err != nil {
// 		log.Printf("unable to find host ip")
// 		log.Fatalf("error message: %s", err)
// 	}
//
// 	// retrieve host ip address
// 	localIP := conn.LocalAddr().(*net.UDPAddr).IP
//
// 	// setup tcp listener
// 	l, err := net.Listen("tcp", fmt.Sprintf("%s:0", localIP))
// 	if err != nil {
// 		log.Println("unable to start tcp listener")
// 		log.Fatalf("error message: %s", err)
// 	}
// 	log.Printf("http server: %s", l.Addr().String())
//
// 	// store http addr
// 	b.HTTPAddr = l.Addr().String()
//
// 	// setup http server
// 	mux := http.NewServeMux()
//
// 	// the plain text password needs to be crypted for template use
// 	guestPasswordCrypted, err := generateCryptedPassword(b.VirtualMachine.Password)
// 	if err != nil {
// 		log.Println("unable to bcrypt password")
// 		log.Fatalf("error message: %s", err)
// 	}
//
// 	// setup a installerVars struct to hold variables needed for the installer template file
// 	vars := installerVars{
// 		VirtualMachineName: b.VirtualMachine.Name,
// 		GuestUser:          b.VirtualMachine.User,
// 		GuestPassword:      string(guestPasswordCrypted),
// 		GuestPublicKey:      b.VirtualMachine.PublicKey,
// 		HTTPAddr:           b.HTTPAddr,
// 	}
//
// 	// setup installer handler
// 	// installer => installer/os/version/http_templates
// 	templateDirPath := fmt.Sprintf("installer_templates/%s/%s/http_templates", b.VirtualMachine.OperatingSystem, b.VirtualMachine.OperatingSystemVersion)
// 	mux.HandleFunc("/installer/", b.installerHandler(templates, templateDirPath, vars))
//
// 	// setup blobs handler
// 	// blob => blob/os/version/
// 	blobDirPath := fmt.Sprintf("%s/%s/%s", b.Blob.DirPath, b.VirtualMachine.OperatingSystem, b.VirtualMachine.OperatingSystemVersion)
// 	mux.Handle("/blob/", http.StripPrefix("/blob/", http.FileServer(http.Dir(blobDirPath))))
//
// 	// setup the default route to use mux router
// 	http.Handle("/", mux)
//
// 	// start up http server
// 	go func() {
// 		err = http.Serve(l, nil)
// 		if err != nil {
// 			log.Println("failed to serve http")
// 			log.Fatalf("error message: %s", err)
// 		}
// 	}()
// }

// generateCryptedPassword uses the openssl binary to determine the crypt hash, the plain text password is passed via stdin.

func generateCryptedPassword(password string) (string, error) {

	// prepare command
	cmd := exec.Command(openSSLPath, "passwd", "-6", "-stdin")
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
