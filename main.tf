# Welcome to the chocoserver module! This module creates a basic Windows Server 2016 instance
# designed for use with Chocolately Server (a project of Chocolately.org).

# First create security group to access the instance via WinRM over HTTP and HTTPS.
resource "aws_security_group" "winrm_enabled" {
  name        = "Allow WinRM Traffic"
  description = "Allow access over WinRM for remote management."

  # WinRM access from anywhere.
  ingress {
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Lookup the current Windows Server 2016 AMI from Amazon.
data "aws_ami" "amazon_windows_2016" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }
}

# Create the EC2 instance for the Chocolately server.
# Uses recommended machine specs from https://chocolatey.org/docs/how-to-set-up-chocolatey-server#requirements.
resource "aws_instance" "chocoserver" {
  # Set instance size to 2 vCPUs and 8GiB RAM.

  instance_type = "t2.large"
  ami           = "${data.aws_ami.amazon_windows_2016.image_id}"

  # Increase default EBS volume size to 50GB SSD, minimum recommended for package store & OS.

  root_block_device = {
    volume_size = "50"
  }

  # The name of the SSH keypair you've created and downloaded from the AWS console.

  key_name = "${var.key_name}"

  # Add security group for WinRM access.

  security_groups = ["winrm_enabled"]

  # Bootstrap instance for WinRM over HTTP with basic authentication. 
  # Don't include this section if you wish to use HTTPS or will manage the instance with Chef or another tool.

  user_data = <<EOF
<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
</script>
<powershell>
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  $user = [adsi]"WinNT://localhost/Administrator,user"
  $user.SetPassword("${var.admin_password}")
  $user.SetInfo()
  Write-Host "Restarting WinRM Service..."
  Stop-Service winrm
  Set-Service winrm -StartupType "Automatic"
  Start-Service winrm
</powershell>
EOF
}
