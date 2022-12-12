output "adb-workspaceid" {
  value = azurerm_databricks_workspace.adb.workspace_id
  description = "workspace id of adb"
}

output "adb-workspaceurl" {
  value = azurerm_databricks_workspace.adb.workspace_url
  description = "workspace url of adb"
}