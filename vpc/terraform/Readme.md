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