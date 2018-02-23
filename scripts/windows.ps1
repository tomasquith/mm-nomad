Set-PsDebug -trace 1

# firewall off
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Add-WindowsFeature containers
# Invoke-WebRequest "https://master.dockerproject.org/windows/x86_64/docker.zip" -OutFile "$env:TEMP\docker.zip" -UseBasicParsing
# Expand-Archive -Path "$env:TEMP\docker.zip" -DestinationPath $env:ProgramFiles
# Add path to this PowerShell session immediately
# $env:path += ";$env:ProgramFiles\Docker"

# For persistent use after a reboot
# $existingMachinePath = [Environment]::GetEnvironmentVariable("Path",[System.EnvironmentVariableTarget]::Machine)
# [Environment]::SetEnvironmentVariable("Path", $existingMachinePath + ";$env:ProgramFiles\Docker", [EnvironmentVariableTarget]::Machine)
# $env:ProgramFiles\docker\dockerd.exe --register-service
# Start-Service Docker

Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider -Force

cinst consul -y

@'
{
    "server": false,
    "datacenter": "dc1",
    "data_dir": "C:\\ProgramData\\consul\\data",
    "encrypt": "X4SYOinf2pTAcAHRhpj7dA==",
    "log_level": "INFO",
    "enable_syslog": false,
    "bind_addr": "192.168.56.102",
	"retry_join": ["192.168.56.101"]
}
'@ | Set-Content C:\ProgramData\consul\config\client.json

cinst nomad -y

@'
datacenter = "dc1"
data_dir   = "C:\\ProgramData\\nomad\\data"

addresses {
  http = "0.0.0.0"
  rpc  = "192.168.56.102"
  serf = "192.168.56.102"
}

client {
  enabled = true
  node_class = "windows"
  options = {
    "driver.whitelist" = "docker"
  }
}
'@ | Set-Content C:\ProgramData\nomad\conf\client.hcl

cinst notepadplusplus -y

Write-Host "Need to restart windows, then start docker, consul and nomad"