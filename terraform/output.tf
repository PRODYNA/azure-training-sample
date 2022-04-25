output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "vm_public_ips" {
  value = { for v in module.wordpress : v.vm_name => v.vm_public_ip }
}
