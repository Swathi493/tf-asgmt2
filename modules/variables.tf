variable "rsgrp" {
  type        = string
  description = "Name of the resource group"
  default     = "devops-rg"
}

variable "location" {
  type        = string
  description = "Location for deploying resources"
  default     = "eastus"
}



variable "data_factory_name" {
  type        = string
  description = "Name of the azure data factory"
}
variable "data_bricks_name" {
  type        = string
  description = "Name of the azure data bricks"
}
variable "vn_name" {
  type        = string
  description = "Name of the azure virtual network"
}
variable "sn_name" {
  type        = string
  description = "Name of the azure subnet"
}
variable "sql_server_name" {
  type        = string
  description = "Name of the azure sql server"
}

variable "vnet_cidr_prefix" {
  type = string
  description = "This variable defines address space for vnet"
}

variable "subnet1_cidr_prefix" {
  type = string
  description = "This variable defines address space for subnetnet"
}
variable "admin" {
  type = string
  description = "This variable defines admin name for sql"
}
variable "storage_account_name" {
  type = string
  description = "This variable defines storage account name"
}
variable "user_names" {
  type = list
  description = "This variable defines list of container names"
}
variable "adf_pipeline_name" {
  type = string
  description = "This variable defines adf pipeline name"
}
variable "linked_service_name" {
  type = string
  description = "This variable defines adf linked service name"
}
variable "client_id" {
  type = string
  description = "This variable defines client id"
}
variable "client_secret" {
  type = string
  description = "This variable defines client secret"
}
variable "tenant_id" {
  type = string
  description = "This variable defines tenant id"
}
variable "func_app_name" {
  type        = string
  description = "Name of the azure function app"
}
variable "service_principle_name" {
  type        = string
  description = "Name of the azure service principal"
}
variable "kustocluster" {
  type        = string
  description = "Name of the kusto cluster"
}
variable "analysis_server" {
  type        = string
  description = "Name of the analysis server"
}
variable "sqldbname" {
  type        = string
  description = "Name of sql database"
}

variable "sqlelasticpoolname" {
  type        = string
  description = "Name of sql elastic pool"
}


variable "tags" {
  type = object({
    created_by       = string
    created_for      = string
    
  })
}