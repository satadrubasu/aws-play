

### Chap-24 [ AWS Security and Encryption ]

#### 24.1 AWS Secret Manager
-------------------
 1. Key Value stored with encryption key and secret name alias.
 2.  API_KEY = 123sggdbsk
 3.  RDS | Aurora | Redshift | documentDB | Other Type ( Lambda )
 4.  Automatic Rotation + Auto Sync with services above.
 5.  Link to the Lambda function with permission to rotate the key

#### 24.2 CloudHSM ( AWS provisioned encryption hardware )
-------------------
 1. Control of the master key and cryptograpphic functions  - unlike KMS (where AWS manages the soft encryption)
 2. Hardened Device which stores crypto functions / keys as owned by clients
 3. CloudHSM Client connects to HSM Cluster (Multi AZ)

#### 24.3 Shield - DDos ( Layer 3/4) ( Syn)
----------------------
1. Shield Standard - activated by default
2. Shield Advanced - 3000$/month -
   a) Optional DDos Mitigation service
   b) Route53 | EC2 | ELB | Cloudfront | Global Accelarator
   c) DDos Response Team


#### 24.4 WAF - DDos ( Layer 7 - HTTP)
----------------------
1) ALB | API Gateway | Cloudfront ONLY
2) Define WebACL
    IP Addr | Http Headers | Http body | URI Strings
3) SQL Injection Cross Site Scripting.
4)  Geo Match block country
5) DDos ( Rate based rules ) - count occurrences of events and block as per.

#### 24.5 AWS Firewall Manager
-----------------------
1) Manage rules in all accounts of an AWS Org.
2) Common set of security rules.(WAF | AWS Shield Advanced | SG for EC2 and ENI resources of VPC)

#### 24.6 Gaurd Duty[ML] ( Intelligent Threat discovery ) ( prevent Cryptocurrency attacks)
-----------------------
1) 1 click install , use ML Learning --> Cloudwatch Event --> SNS / Lambda
2) Cloudtrail | VPC Flow | DNS logs Input
3) setup Cloudwatch Event rules to be notified in case of findings
4) Event Rules target AWS Lambda or SNS

#### 24.7 Amazon Macie[ML]  ( Data Security and Privacy with ML )
-------------------------------------  
1) Identify PII
2) S3 -->(analyze) --> Macie (Discover PII data) --> (notify) --> Cloudwatch Events Bridge -->

#### 24.8 Amazon Inspector  ( EC2 ONLY )
-----------------------
1) Install Agent onto EC2
2) Agent connects to Inspector Service
3) Network and Host Assessments / OS security and soft securtity issues

