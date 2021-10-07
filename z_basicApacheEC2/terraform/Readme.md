
## Pre Reuisite :

 1. The credentials with the profile of alphauser for the account :  
  ```
  ~/.aws $ cat credentials
[default]
aws_access_key_id = AKI$$$$$$$$$$$$VDU55 
aws_access_key_id = AK2NKVDU55 

[alphauser]
aws_access_key_id = AKI$$$$$$$$$$$$VDU55 
aws_secret_access_key =  ssssssssssssssQEeaw
  ```

### Usage with default values placed in tfvars file
 > terraform init  
 > terraform apply -var-file dev-variables.tfvars

### Inspect the state

 > terraform state list  
 > terraform state show <item_from_outout>  

