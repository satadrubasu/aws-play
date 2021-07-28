
[Chap 12]
======  S3  ================

 1) Security
    User based
    Resource Based -
       (Bucket Policies) Allow Cross Account access
       (OACL )Object Access Control List - finer grain
       (BACL) )Bucket Access Control List - less common

  2) Access Resolution Logic if IAM Principal can access:
    ((user IAM permission allow) OR (Resource policy allow))
      AND
      (NO Explicit DENY)

  3) Supports VPC Endpoints to have S3 access without internet.
  4) Logging and Audit :
      S3 Access Logs can be stored in other S3 Bucket
      API Calls logged in AWS Cloudtrail
  5) Pre-Signed URLs - valid for limited time
       - e.g prem video service for logged in users.
       - sdk to generate the url and return to app to be used

  6) Static Websites :
     www.<bucket-name>.s3-website-<AWS-region>.amazonaws.com
     www.<bucket-name>.s3-website.<AWS-region>.amazonaws.com

  7) CORS (Cross Origin resource Sharing)
     Origin = protocol + host + port
     Browser based mech to allow requests to other origins while visiting same origin.
     E.g diff origin - http://www.ex-1.com/app1 --> http://www.other.ex-1.com
     Request wont be fulfilled unless the other origin allows for CORS header ;
      Access-Control-Allow-Origin:

      i) Web Browser --> Preflight to Cross Origin
      OPTIONS/
         Host: www.other.com
         Origin: https:/www.example.com
     ii) Cross Origin response to Browser :
         Access-Control-Allow-Origin  : http://www.example.com
         Access-Control-Allow-Methods : GET,PUT,DELETE
     iii) Browser GET call to cross origin [ www.other.com ]
        GET/
        Host: www.other.com
        Origin: http://www.example.com

     -- S3 CORS --
     If client does a S3 CORS request on static Website ?
     Enable correct CORS headers.
     Allow for a specific origin or all *

   8) Event Notifications = Lambda | SNS | SQS
   9) Transfer Acceleration :
        Amazon S3 Transfer Acceleration is a bucket-level feature that enables fast, easy, and secure transfers of files over long distances between your client and an S3 bucket. Transfer Acceleration takes advantage of the globally distributed edge locations in Amazon CloudFront. As the data arrives at an edge location, the data is routed to Amazon S3 over an optimized network path.
        - Your customers upload to a centralized bucket from all over the world.
        - You transfer gigabytes to terabytes of data on a regular basis across continents.
        - You can't use all of your available bandwidth over the internet when uploading to Amazon S3.
        - To access the bucket that is enabled for Transfer Acceleration, you must use the endpoint bucketname.s3-accelerate.amazonaws.com. Or, use the dual-stack endpoint bucketname.s3-accelerate.dualstack.amazonaws.com to connect to the enabled bucket over IPv6
  10) Requestor Pays --
      - You must authenticate all requests involving Requester Pays buckets. The request authentication enables Amazon S3 to identify and charge the requester for their use of the Requester Pays bucket.
      - Anonymous requests
  11) Static Website Hosting
  12) Replication [ Pre-req - versioning]
      - to other accounts / regions
      - Encryption allowed using AWS KMS
      - RTC Option = 15 minutes 99.99 % new objects replicated
      - delete marker Replication
      - Replication to another Storage class
  13) Amazon S3 Access Points simplify managing data access at scale for shared datasets in S3. Access points are named network endpoints that are attached to buckets that you can use to perform S3 object operations. An Access Point alias provides the same functionality as an Access Point ARN and can be substituted for use anywhere an S3 bucket name is normally used for data access.
  14) Object Lmbda Access Points [ Transform ]
      Amazon S3 Object Lambda Access Points allow you to run custom transformations when retrieving objects

  15) CloudFront Distribution - [ Enable CF and link to bucket]
      Bucket becomes pvt
      OAI ( Origin Access ID generated and associated with CF Distribution)
      CF generates the domain which takes 4-5 hrs to propogate to all DNS
      And then access is restricted to only those with CF URL.
      No More access to S3 bucket directly but via OAI with CF.


[Ch 14] Advanced S3 and Athena
=================
 1) S3 MFA Delete
   - only by root
   - enable versioning

2) S3 Default Encryption vs Bucket Policies
   - bucket policy will apply to all data incoming
   - S3 default option enabled with aws S3 key

3) Access Logs ( Server )
   - Access Logs --> Logging Bucket --> Athena
   - Never set logging bucket to the same bucket else a loop.
   - ACL rule is automatically added
4) S3 Replication
    - After activation - ONLY New Objects replicated
    - CRR ( Cross Region Replication )

    - SRR ( Same region replication )
        ( Compliance )
    - REPLICATION NOT CHAINED
       S1 --> S2 --> S3   doesn't happen

5) S3 Glacier restore
    Bulk retrieving = 5-12 hrs
    Standard  = 3-5 hrs
    Expedited  = 1-5 mins < 250 MB

6) S3 Analytics - Storage class analysis
   - Step to improve Lifecycle rules and determine transition
      of objects from SA to SA-IA
   - reports updated daily
   - takes 24h to 48 h for first start

7) S3 Performance : [ Per PREFIX ]
   - PER PREFIX :
    3500 PUT/COPY/POST/Delete
    5500 Get / HEAD requests per second per prefix
   - S3 - KMS Limitation
     throttled by HMS quota per region
   - Multi part upload  (Introduce parallel upload)
       > 100 MB recommended
       > 5GB - must
   - S3 Transfer acceleration :
       upload to edge and move via AWS internal n/w to Bucket in origin.

   - S3 Download increase performance (Parallel read chuncks)
      - S3 Byte-Range Fetches
         i) header first in 50 bytes and then decide

  8) S3 Select & Glacier Select [Server level filter first and return data]
      - Filtering of S3 data to fetch
  9) S3 Object locked for specific time or no expiration
     Governance Mode - auth users can change others cant  
     Compliance Mode - No One can


[Ch 16]
===========
1. AWS Snow Family
  i) DATA Migration - migrate data in/out of aws
     - Snowcone (Small desert /water safe )- [8TB] AWS DataSync or send to AWS
        Datasync Agent preinstalled - upto 24TB Use cases
     - Snowball edge [80TB Store opt]  [42TB Compute Opt]
        Upto PB offline use cases
     - Snowmobile
        Upto Exabytes

  ii) Edge Computing - Collect and process data at edge
     - Snowcone ( 2cpus , 4GB , USBC
     - Snowball Edge ( 40 vcpus 80GB , clustering , run EC2 / Lambda )

  iii) Snowball to Glacier ( HOW To )
     - No direct load to Glacier
     - Snowball --> S3 --> Lifecycle policy to Glacier


2. Hybrid Cloud Storage | S3 is AWS prop how do we access from on prem
     Types =
     Block - EBS
     File -  EFS | FSx
     Object - S3 | Glacier

3. Storage Gateway types :
   - File Gateway
       [ On Prem App]--NFS/SMB--> [File GW] ---> Https --> S3 ( Std,IA )

      i) S3 access using NFS and SMB protocols
      ii) S3 standard + S3 IA + S3 OZ IA
      iii) Bucket access using IAM role for each FGw
      iv) Cache on FGw for recent data
       v) Integrated with AD for user authenticate
      vi) Mount on many on-prem servers

   - Volume Gateway [ Cached OR Stored ]
      [ On Prem App] -- iSCSI--> [Vol Gw] --> https --> S3
      i)  Block Storage using iSCSI protocol backed by S3
      ii) Help Restore on-prem volumes
      iii) Cached -> low latency access to most recent data
           Stored -> entire dataset is on-prem , scheduled backups to S3

   - Tape Gateway
     [On Prem App] --iSCSI--> [Tape Gateway]--> HTTPS --> [Virtual tapes stored in S3]

4.   SGateway - as Hardware appliance
   ------- NON Gateway Storge ------

5. FSx for Windows (File Server) [ Behind ENI ]
    - SMB & NTFS
    - AD integration
    - can be accessed from on Prem
    - Can be Multi-AZ
    - Data is backed-up daily to S3

6. Amazon FSx for Lustre [ Behind ENI ](Parallel distributed FSystem )
   - Linux cluster
   - Large Scale computing (HPC + ML )
   - Video processing / Financial Modelling
   - Integrated with S3
   - 2 deployment options :

      i) Scratch File System
          temp storge | data not replicated , server fail = loss
          high burst ( 6x faster , 200 MBps per TiB )
          Usage - Short-term processing
      ii) Persistent File System
          Long-term storage
          Data is replicated within same AZ
          Replaced failed files within minutes
          Usage - Long-term processing, sensitive data
 7. AWS Transfer Family  [IN/Out of S3 or EFS using FTP ]
    - FTP / FTPS / SFTP service
    - MS AD LDAP auth
    Users --> Route53 --> AWS Transfer Family -->IAM Role --> S3 | EFS


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

