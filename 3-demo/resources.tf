##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  subscription_id = "${var.arm_subscription}"
  client_id = "${var.arm_appId}"
  client_secret     = "${var.arm_password}"
  tenant_id = "${var.arm_tenant}"
}

##################################################################################
# DATA
##################################################################################

data "terraform_remote_state" "2-demo" {
    backend = "azurerm"
    config {
        storage_account_name  = "azug11142018remotestate"
        container_name        = "azug11142018-remotestate-demos"
        key                   = "2-demo.state"
        resource_group_name = "azug11142018-setup"
        arm_client_id = "${var.arm_appId}"
        arm_client_secret = "${var.arm_password}"
    }
}

##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group}"
  location = "${var.arm_region}"
}

module "loadbalancer" {
  source              = "Azure/loadbalancer/azurerm"
  resource_group_name = "${local.resource_group}"
  location            = "${var.arm_region}"
  prefix              = "azug-11192018"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http = ["80", "Tcp", "80"]
  }
}

module "computegroup" {
    source              = "Azure/computegroup/azurerm"
    resource_group_name = "${local.resource_group}"
    location            = "${var.arm_region}"
    vm_size             = "Standard_A0"
    admin_username      = "azureuser"
    admin_password      = "ComplexPassword"
    ssh_key             = "~/.ssh/nbellavancePublic.pem"
    nb_instance         = 2
    vm_os_simple        = "UbuntuServer"
    vnet_subnet_id      = "${data.terraform_remote_state.2-demo.subnet_1}"
    load_balancer_backend_address_pool_ids = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
    cmd_extension       = "sudo apt-get -y install nginx"
    tags                = {
                            environment = "dev"
                            costcenter  = "it"
                          }
}


