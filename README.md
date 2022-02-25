# aws-play



### Install httpd
```
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

cat << EOF > /var/www/html/index.html
<html>
 <body>
   Hello from the server
 </body>
</html>
EOF

```


### Skeleton Steps :

1. VPC : Subnet choice for pvt subnet blocks by IANA : 
  10.0.0.0/8    ( big networks )
  172.16.0.0/12 ( AWS Default VPC)
  192.168.0.0   ( Typical home network )
 
  i) max 5 vpcs in a region
  ii) min /28 = 16 ips | max /16 (65536)
  iii) Have 5 multiple CIDRs at max in same vpc

* Aws reserves 5 IPs [ first 4 and last 1 ]
* .0 - network address
* .1 - vpc router
* .2 - mapping to aws provided dns
* .3 - future use
* .last - broadcast reserved not supported

2. Subnet : Belong to specific AZ { spread for HA } 
   i) Subnet Route Table
   ii) Subnet Network ACL

   i) Route Table :  
      10.0.1.0/26  - local
      0.0.0.0/0    - igw-000 [ Attached to VPC]

 Subnet calculator = https://www.davidc.net/sites/default/subnets/subnets.html  
```
 VPC = 10.0.1.0/24  = 256 IPs
 pub-subnet-1 =   10.0.1.0/26   |   10.0.1.0 -  10.0.1.63 | 62 hosts | AZ1
 pvt-subnet-1 =  10.0.1.64/26   |  10.0.1.64 - 10.0.1.127 | 62 hosts | AZ1
 
 pub-subnet-2 = 10.0.1.128/26   | 10.0.1.128 - 10.0.1.191 | 62 hosts | AZ2
 pvt-subnet-2 = 10.0.1.192/26   | 10.0.1.192 - 10.0.1.254 | 62 hosts | AZ2
```

3. Internet GW :
  - Scales horizontally and is HA and redundant
  - Create separately from a VPC
  - 1 vpc = 1 IGW Association needs to happen post creation
  - VPC route tables need to be configured to link to igw

5. Route Tables :
   i) Create RTs and associate subnets. 
  ii) PUB RT - add IGW route - link with vpc
  iii) PVT RT - no igw - link with vpc 
