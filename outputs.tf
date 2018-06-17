# Output the public DNS address so we know where to connect to using WinRM.
output "Public_DNS" {
  value = "${aws_instance.chocoserver.public_dns}"
}
