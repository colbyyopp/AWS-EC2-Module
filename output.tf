output "instance" {
  value       = { for k, v in aws_instance.this : k => v }
}

output "eni_primary" {
  value       = { for k, v in aws_network_interface.primary : k => v }
}