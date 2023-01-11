package templates

import (
	"fmt"
	"github.com/tenzin-io/vmware-builder/pkg/builder"
	"io"
	"log"
	"net"
	"net/http"
	"os"
	"path"
	"text/template"
)

// installerVars struct is a variable bag passed to a template.
type templateVars struct {
	PackerVars  builder.PackerVars
	HTTPAddress string
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

func LaunchTemplateServer(installersDirPath string, packerVars builder.PackerVars) string {

	// attempt an outbound connection
	conn, err := net.Dial("udp", "1.1.1.1:53")
	if err != nil {
		log.Printf("unable to find host ip")
		log.Fatalf("error message: %s", err)
	}

	// retrieve host address from which we attempted an outbound connection
	localIP := conn.LocalAddr().(*net.UDPAddr).IP

	// setup tcp listener on the host address
	listener, err := net.Listen("tcp", fmt.Sprintf("%s:0", localIP))
	if err != nil {
		log.Println("unable to start tcp listener")
		log.Fatalf("error message: %s", err)
	}

	log.Printf("template http server: %s", listener.Addr().String())

	// setup http mux
	mux := http.NewServeMux()

	// templateVars to give to the templates
	tv := templateVars{
		PackerVars:  packerVars,
		HTTPAddress: listener.Addr().String(),
	}

	// setup the templates path
	templatesDirPath := fmt.Sprintf("%s/%s/%s/templates", installersDirPath, packerVars["vm_linux_distro"], packerVars["vm_linux_distro_release"])
	mux.HandleFunc("/templates/", templatesHandler(templatesDirPath, tv))

	// setup the files path
	filesDirPath := fmt.Sprintf("%s/%s/%s/files", installersDirPath, packerVars["vm_linux_distro"], packerVars["vm_linux_distro_release"])
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
