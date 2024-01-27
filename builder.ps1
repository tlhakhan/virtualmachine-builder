# Import required variables
$PKR_VAR_vm_name = $args[0]

if (-not $PKR_VAR_vm_name) {
    Write-Host "Usage: $([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)) [vm name]"
    exit 1
}

if (-not (Test-Path "overrides.pkrvars.hcl")) {
    Write-Host "Error:"
    Write-Host "Missing overrides.pkrvars.hcl file. See README.md for more details."
    exit 1
}

# Run Packer
$env:PKR_VAR_vm_name = $PKR_VAR_vm_name
packer.exe init packer_template.pkr.hcl
packer.exe validate -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
packer.exe build -var-file overrides.pkrvars.hcl packer_template.pkr.hcl
