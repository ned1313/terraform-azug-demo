##################################################################################
# OUTPUT
##################################################################################

output "vmss_id" {
  value = "${module.vmss-cloudinit.vmss_id}"
}

output "azurerm_public_ip_id" {
  value = "${module.loadbalancer.azurerm_public_ip_id}"
}

output "azurerm_public_ip_address" {
  value = "http://${module.loadbalancer.azurerm_public_ip_address[0]}"
}





