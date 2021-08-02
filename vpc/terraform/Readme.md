### Credential 

----
2. Env Variable :

```
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-west-2"
$ terraform plan
```
----
#### 3. SHared Credentials file  

 The default location is $HOME/.aws/credentials on Linux

```
provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "/home/satadru/.aws/credentials"
  profile                 = "alphauser"
}
```

### Run

 Download all defined provider plugins under .terraform dir created  
 > terraform init  

 Dry run by running the plan  
 > terraform plan  

 Dry run by running the plan   
 > terraform apply  
 
 Dry run by running the plan   
 > terraform destroy  

 Inspect the state   
 > terraform state list  
 > terraform state show <item_from_outout>  
 
 For printing certain created values at end of apply  
 ```
  output "server_public_ip" {
  value = aws_eip.tf_eip_web.public_ip }
 ```
}

 Without applying again to check output detals 
 > terraform refresh  
 > terraform output 

 Target specific resource destroy and reapply without the whole defn
 > terraform destroy -target aws_instance.tf_web_inst  
 > terraform apply -target aws_instance.tf_web_inst 

 Terraform variable
 ```
 variable "availibility_zone_choice" {
    description = "Enter the AZ"
    default = "us-east-2a"
    type = string
  }
 
 resource "aws_subnet" "tf_subnet_web" {
    availibility_zone = var.availibility_zone_choice
    ..
 
 ```

 Terraform file based variables
 > terraform.tfvars
 > terraform apply 
 
Terraform file based variables - custom variable filename to use
 >  terraform apply -var-file prod_terraform.tfvars  

------

## Common Project Use Case reference 

Pre-requisite : Create a key pair [ terraform-devops.pem ]

1. Create VPC
2. Create Internet Gateway
3. Create custom-route-table
4. Create a subnet
5. Associate subnet with each route table
6. Create security group to allow port 22,80,443
7. Create a network Interface with ip in subnet created in step 4.
8. Assign an elastic IP to the network interface created in Step 7
9. Create Ubuntu Server and install/enable apache2

```
Refer to the terraform inside the vpc subfolder 
```

----

### SSH to EC2 instance

For Ubuntu OS :
 > chmod 400 terraform-devops.pem
 > ssh -i 'terraform-devops.pem' ubuntu@<public-ip>  


