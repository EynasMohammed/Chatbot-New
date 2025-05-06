# Get current Azure client details (tenant, object ID, etc.)
data "azurerm_client_config" "current" {}

# Create Azure Key Vault
resource "azurerm_key_vault" "kv" {
  name                        = "${local.resource_name_prefix}-kv-${random_string.myrandom.id}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
}

# Give yourself access to secrets in the Key Vault
resource "azurerm_key_vault_access_policy" "myself" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

   secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Backup",
    "Restore",
    "Recover",
    "Purge"
  ]
}

resource "azurerm_key_vault_access_policy" "vmss" {
  depends_on = [ azurerm_linux_virtual_machine_scale_set.web_vmss ]

  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_virtual_machine_scale_set.web_vmss.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

locals {
  secrets = {
    "PROJ--DB--HOST"               = azurerm_postgresql_flexible_server.db.fqdn
    "PROJ--DB--PORT"               = "5432"
    "PROJ--CHROMADB--HOST"         = azurerm_linux_virtual_machine.web_vm.public_ip_address
    "PROJ--CHROMADB--PORT"         = "8000"
    "PROJ--AZURE--STORAGE--CONTAINER" = azurerm_storage_container.sc.name
  }
}

resource "azurerm_key_vault_secret" "s" {
  depends_on   = [ azurerm_key_vault_access_policy.myself ]
  for_each     = local.secrets
  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.kv.id
}

output "keyvault_name" {
  description = "Key Vault Name"
  value       = azurerm_key_vault.kv.name
}
