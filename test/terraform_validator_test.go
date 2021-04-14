package main

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/davecgh/go-spew/spew"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestValidatorWithPolkashots deploys a validator and enable polkashots and also additional volume
func TestValidatorWithPolkashots(t *testing.T) {
	t.Parallel()

	instanceName := fmt.Sprintf("validator-%s", strings.ToLower(random.UniqueId()))

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)

	spew.Dump(keyPair)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/simple-validator",
		Vars: map[string]interface{}{
			"ssh_key":      keyPair.PublicKey,
			"droplet_name": instanceName,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	publicInstanceIP := terraform.Output(t, terraformOptions, "public_ip")
	httpUsername := terraform.Output(t, terraformOptions, "http_username")
	httpPassword := terraform.Output(t, terraformOptions, "http_password")

	publicHost := ssh.Host{
		Hostname:    publicInstanceIP,
		SshKeyPair:  keyPair,
		SshUserName: "root",
	}

	maxRetries := 30
	timeBetweenRetries := 30 * time.Second
	description := fmt.Sprintf("SSHing to validator %s to check disk size", publicInstanceIP)

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkDiskSize(t, publicHost, 180000000, "/home") // 190G
	})

	description = fmt.Sprintf("Checking if node_exporter is running in %s", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkNodeExporter(t, publicInstanceIP, httpUsername, httpPassword)
	})

	description = fmt.Sprintf("SSHing to validator %s to check if validator has all tools installed", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkBinaries(t, publicHost, "host")
	})

	description = fmt.Sprintf("SSHing in validator (%s) to check if application files exist", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkAppFiles(t, publicHost, "host")
	})

	description = fmt.Sprintf("SSHing to validator (%s) to check if snapshot folder exist and >5GB", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkPolkadotSnapshot(t, publicHost)
	})
}
