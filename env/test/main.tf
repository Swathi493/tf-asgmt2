module "testmodule" {
  source = "../../modules"
  

  data_factory_name= var.data_factory_name
  data_bricks_name = var.data_bricks_name 

 vn_name = var.vn_name
 sn_name = var.sn_name
 sql_server_name = var.sql_server_name
 storage_account_name = var.storage_account_name
 user_names = var.user_names
 vnet_cidr_prefix = var.vnet_cidr_prefix
 subnet1_cidr_prefix = var.subnet1_cidr_prefix
 admin = var.admin
 adf_pipeline_name = var.adf_pipeline_name
  tags = var.tags
  linked_service_name = var.linked_service_name
  tenant_id = var.tenant_id
  client_id = var.client_id
  client_secret = var.client_secret
  func_app_name = var.func_app_name
  service_principle_name = var.service_principle_name
  kustocluster = var.kustocluster
  analysis_server = var.analysis_server
  sqldbname = var.sqldbname
  sqlelasticpoolname = var.sqlelasticpoolname
}