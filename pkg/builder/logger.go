package builder

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os/exec"
	"path"
	"strings"
)

// getCommandString returns a string of the command and args of a *exec.Cmd type
func getCommandString(cmd *exec.Cmd) string {
	basename := path.Base(cmd.Path)
	args := strings.Join(cmd.Args[1:], " ")
	return fmt.Sprintf("%s %s", basename, args)
}

// logPipe wraps an io.ReadCloser with a prefixed message and outputs to
// log.Printf. logPipe returns a done channel of type bool to signal when
// the io.ReadCloser closes.
func logPipe(r io.ReadCloser, format string, message ...interface{}) chan bool {
	done := make(chan bool)
	go func() {
		in := bufio.NewScanner(r)
		for in.Scan() {
			log.Printf("%s: %s", fmt.Sprintf(format, message...), in.Text())
		}
		done <- true
	}()
	return done
}
