package cmd
import(
  "fmt"
  "github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
  Use: "builder",
  Short: "Builder is a virtual machine builder on ESXi hosts",
  Long: "A easy to use virtual machine build tool."
}
func Execute() error {
  return rootCmd.Execute()
}
