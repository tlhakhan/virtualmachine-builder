package builder

import(
  "log")

// init will verify that the builder has all run-time dependencies to build virtual machine.
func init() {
  log.Println("builder initialized.")
}
