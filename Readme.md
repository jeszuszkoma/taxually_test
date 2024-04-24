# This document created for to describe the Taxually Homework

### Safety notice: Now you can see hardcoded passwords etc, but because the company is using Azure DevOps Pipelines, we can change them into secure variables and use these secure variables for all the sensitive values.

### Resources
- Resource Group
- Service Plan
- Storage account
- Service Bus Namespace
- Service Bus Queue
- SQL Server
- SQL Firewall Rule
- SQL Database
- Web App Service
- Function Application
- APIM (API Management)

### Variables
- resource_group_name
- location: To define where we host our resources
- environmentName: To identify the resource environment
- environmentType: To identify the resource tag eg. Dev, Test, Prod
- project: The name of the project
- app_service_plan: Define the service plan we want to use for our web and function application/We can create different plans for different applications
- sql_admin:Use this username to create and log in as an administrator to SQL Server
- sql_admin_password: The admin password for the sql_admin
- testxam_servicebus_namespace
- testxam_servicebus_queue

### Locals
- common_tags: We can use these tags as our resource tags for the easier findings

### Functions
- Resource Group: It stores our resources for projects
- Service Plan: For Dev environment use B1 because of we are just testing features and we don't expect high usage. On Test and Prod environments have to scale up this plan depending on user demands. (Different high performance plans: S1, P1V3, etc)
- Storage account: the storage account is integral for managing function code, state, and infrastructure. On this project we use it for the function application logs.
- Service Bus Namespace & Queue: Service Bus namespaces and queues are essential for building distributed, asynchronous, and reliable communication patterns in our applications. They enhance scalability, resilience, and security while ensuring ordered message processing between our Web and Function Application.
- SQL Server and Database: Assuming that we will run an enterprise application on the app service which will handle data and not just files(blob storage) because of that I have created a relational database.
- SQL Firewall Rule: Created for security reason. Use the start and end ip address as 0.0.0.0, to enable Azure services to connect/communicate to each other.
- App Service: Used linux because it is cheaper than Windows. Because of the security rule I used AAD authentication to log in to the page. For this, first of all need to register our application and configure. Need to choose who can use the application or the API if we add some API there. I choosed Accounts in this organization only, after we finished with that need to configure the redirect URI as a Web and add our app service URL.

| client ID | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx |
| ------ | ------ |
| Tenant ID | https://login.microsoftonline.com/<tenant-id> |
Client ID: After we registered our application we will find this in the overview section
Tenant ID: We will find it under the apps endpoints we need the WS-Federation sign-on endpoint without /wsfed.
- Function App: Use for various work items of different types. With Function Applications we can handle easy small tasks and resource intensive tasks as well.
- APIM (API MAnagement): Choose this because it is a managed service for creating, publishing, securing, and analyzing APIs. Pros: Centralized management, built-in features like rate limiting, caching, and analytics, separation of concerns. Cons: Additional cost, learning curve.

### Run
To Run Terraform you will need to make some steps before you start with the resource-creating phase.

#### Before you start your installation need to create a Terraform-POC backend resource group with "anystorageaccname". -> need to change it on the code as well to your specific storage account name
This storage account will store our state from our project resources and Terraform will use them under the deployment

MAC users:
```sh
cd **/Project-Folder
brew install terraform
az login
az account set --subscription "sub_name"
terraform init
terraform plan
terraform apply
```

Cent OS/RHEL
```sh
cd **/Project-Folder
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
az login
az account set --subscription "sub_name"
terraform init
terraform plan
terraform apply
```

Windows:
```sh
cd **/Project-Folder
choco install terraform
az login
az account set --subscription "sub_name"
terraform init
terraform plan
terraform apply
```