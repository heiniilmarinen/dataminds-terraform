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



# 3. Use Variables

## Add variables

We have started to possibly repeat some naming patterns across our resources, so it would make sense to define this as a variable.

1. Create a `variables.tf` file in your directory.

2. Define a variable block with name `env_name`, add `type = string` and `default = "your value to use in names of resources"`

3. Update your previous resources (resource group and Azure SQL resources) to reference this variable. You can for example update the database resource name to be:
```
name      = "db-${var.env_name}"
```

## Add outputs

There might also be some values from our resources that we might need to print out after a deployment process or we might need to reference a value from a separate Terraform configuration. In that case we need outputs.

1. Create a `output.tf` file in your directory.

2. Create an output block named `sql-endpoint` with the following parameter:
```
value = azurerm_mssql_server.this.fully_qualified_domain_name
```

## Terraform validate

When you are making bigger changes to your Terraform confguration, it is a good idea to validate it with `terraform validate`. After this you can proceed with `terraform plan` and `terraform apply` steps as usual.



# 4. Handle existing resources

Create a resource of your choosing, for example Data Factory in your resource group through the Azure portal or Azure CLI in the same resource group you created previously. Try running `terraform plan` after this and see what happens.

Terraform will not become automatically aware of this new resource, instead they need to be imported to Terraform state. 

Find the Terraform documentation page for the resource you chose to create. Grab the sample from the documentation, but change the terraform name for the resource to what you would like it to be, for example `df` for Data Factory. Now run `terraform plan` again, Terraform will think that it will have to create these resources.

Find the import section on the Terraform documentation and verify how the resource should be imported. You can find the Terraform resource reference from the plan and then you will need to fetch the resource id from the Azure portal. Your import command should look something like this:

```
terraform import azurerm_data_factory.df /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example/providers/Microsoft.DataFactory/factories/df-your-unique-name
```