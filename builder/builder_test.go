package builder

import "testing"

func TestParseEnvironmentFile(t *testing.T) {
  envFilePath := "test_env.yml"
  env := parseEnvironmentFile(envFilePath)
  if env.BuildHost.Server != "build-00" {
    t.Errorf("failed")
  }
}
