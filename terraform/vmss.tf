locals {
  # This id is from the VM Image we created. You can get this from the Azure Portal -> JSON View -> id
  source_image_id = "/subscriptions/1a93c609-1e7c-4f6f-9399-c54924c1d80e/resourceGroups/SDA-Stage6.5/providers/Microsoft.Compute/galleries/myimages/images/chatbot.image/versions/1.0.0"
}

resource "azurerm_linux_virtual_machine_scale_set" "web_vmss" {
  name                = "${local.resource_name_prefix}-web-vmss-${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_D2s_v6"
  instances           = 2
  admin_username      = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/eynas/OneDrive/المستندات/BootCamp-cc/Chatbot-project/Chatbot-project.pub")
  }

    source_image_id       = local.source_image_id

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  upgrade_mode          = "Automatic"
  secure_boot_enabled   = true  # enable secure boot

  identity {
    type = "SystemAssigned"
  }

  network_interface {
    name    = "web-vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.websubnet.id
      application_gateway_backend_address_pool_ids = [
        tolist(azurerm_application_gateway.web_ag.backend_address_pool)[0].id
      ]
    }
  }
}
  output "web_vmss_id" {
    description = "Web Virtual Machine Scale Set ID"
    value       = azurerm_linux_virtual_machine_scale_set.web_vmss.id
  }

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "myAutoscaleSetting"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.web_vmss.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 3
    }

    rule {
  metric_trigger {
    metric_name        = "Percentage CPU"
    metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
    time_grain         = "PT1M"         # 1 minute
    statistic          = "Average"
    time_window        = "PT5M"         # 5 minutes
    time_aggregation   = "Average"
    operator           = "GreaterThan"
    threshold          = 80
    metric_namespace   = "microsoft.compute/virtualmachinescalesets"
  }

scale_action {
  direction = "Increase"
  type      = "ChangeCount"
  value     = "1"
  cooldown  = "PT1M"
}
    }

    rule {
  metric_trigger {
    metric_name        = "Percentage CPU"
    metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
    time_grain         = "PT1M"
    statistic          = "Average"
    time_window        = "PT5M"
    time_aggregation   = "Average"
    operator           = "LessThan"
    threshold          = 20
  }
scale_action {
  direction = "Decrease"
  type      = "ChangeCount"
  value     = "1"
  cooldown  = "PT1M"
}
    }
  }
}

