# Configure the RAT CI Azure VM.
# Run with: az vm run-command invoke --resource-group rat-ci-vmimagegen --name rat-ci-vm --command-id 'RunPowerShellScript' --scripts @rat-ci-vm-setup.ps1
# - Expand the disk to maximum partition size.
# - Create a new user (`AzDevOps`) and add to Administrator's group.
# - Restart the Computer.

# Increase drive space to max allocated
$MaxSize = (Get-PartitionSupportedSize -DriveLetter c).sizeMax
Resize-Partition -DriveLetter c -Size $MaxSize

# Create new 'AzDevOps' user and add to Local Administrators group.
# The password is irrelevant, as it will be replaced when Azure Devops configures the agent.
$password = ConvertTo-SecureString "replaceable" -AsPlainText -Force
New-LocalUser "AzDevOps" -Password $password -FullName "Azure DevOps Agent User" -Description "Azure DevOps Agent User"
Add-LocalGroupMember -Group "Administrators" -Member "AzDevOps"

# Restart computer once completed to ensure all changes take effect.
Restart-Computer -Force
