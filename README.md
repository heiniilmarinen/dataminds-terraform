# dataMinds Connect 2022

In this repo you can find the pre-con exercises for **Less Clicking, More Sanity! Azure Data Platform Development Using Infrastructure as Code**

## Getting started

You will need your favorite IDE for creating and editing your Terraform files. If you don't have one installed yet, Visual Studio Code is convenient to use. You can download it from [here](https://code.visualstudio.com/). If you are using VS Code, I also recommend installing the HashiCorp Terraform extension.

In addition you will need Terrform on your machine, find the instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started) for all major operating systems.

Lastly, to authenticate with Azure, you need Azure CLI, which you can download from [this link](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).

Create a working directory, for example `terraform`, that you will start working in. You can also clone or fork this repo and create a working directory for creating your Terraform configuration.

## Authenticating to Azure 

For these exercises, you will need an Azure subscription that you can work with. We will use authentication with Azure CLI, so run the following to get logged in:

```
az login

# Check your default subscription
az account show

# If needed choose a different subscription
az account set -s "Your subscription name or id"
```


# 1. Initialization

Whenever you create a new Terraform project you will need to initialize it and setup your provider (in this case Azure).

Create `main.tf` file. It will have all basic configuration for your project.


## Terraform configuration
Usually provider and Terraform configuration are done in your `main.tf` file. Check the latest [Terraform Azure provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs). Add the following, you can update the provider to the latest, but note that it might require some changes in resource configurations as well.

```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.26.0"
    }
  }
}

provider "azurerm" {
  features {}
}

```

## Initializing Terraform

We need to initialize Terraform to download all required modules and packages to be used.
You need to re-initialize every time you touch one of the modules, change versions etc...

```
terraform init
```

## Terraform workflow

In the `main.tf` file add your first resource configuration for a resource group and update with the name and location that you wish to use.

```
resource "azurerm_resource_group" "rg" {
  name = ""
  location = ""
}
```
When you are ready with your configuration, check your changes with `terraform plan`. 

To apply your changes run `terraform apply`.

To delete your resources run `terraform destroy`.



# 2. Managing resources

## Define resources

What are the resources that you are going to need for your data solution? We are going to start creating specific resources through these exercises, but feel free to focus on the resources that are most relevant to you. The important thing is not the specific resource you use in each part of the exercise, but that you practice each skill.

Let's start by creating an Azure SQL database, first check the Terraform provider information for the [resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) and check what information you need.

According to the sample you are going to need a sql server resource as well as a database resource. Check also the Azure SQL server resource [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) and specifically make note of the required properties. 

1. Start with creating a `sql.tf` file. 

2. Create a resource block with type `azurerm_mssql_server` and name `sql' and add the required parameters:

```
name = "sql-your-unique-name"

resource_group_name = azurerm_resource_group.rg.name
location            = azurerm_resource_group.rg.location

version                      = "12.0"

administrator_login          = "sqladmin"
administrator_login_password = "random2o342874!"
```
Note that we are able to reference other terraform resources with `<resource_type>.<resource_name>.<property>`. We use this method to get the resource group name and location.

This is not the best place to handle secrets, but we will return to this at a later phase.

3. In the `sql.tf` file, create a resource block with type azurerm_mssql_database and name this with parameters:
```
name      = "db-your-unique-name"
server_id =
sku_name  = "Basic"
```
We also need to reference the server we defined above. How can you reference the id of that server? **Hint:** Check how we referenced the resource group name and location.

## Modify resources

Change some of the parameters in your resource configurations one at a time and see what kind of changes that results in. Can you find changes that are applied on the fly? How about chenges that force the resource to be created again?