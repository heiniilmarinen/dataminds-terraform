output "key_vault_id" {
  description = "Key Vault id of the created Key Vault"
  value       = azurerm_key_vault.key_vault.id
}
