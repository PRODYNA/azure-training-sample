module "wordpress" {
  source   = "./modules/azure-vm"
  for_each = toset(local.instances)

  resource_group_name = var.resource_group_name
  instance_id         = each.key
  subnet_id           = azurerm_subnet.default.id
  pip_id              = azurerm_public_ip.vm[each.key].id
  asg_id              = azurerm_application_security_group.web.id
}
