
Analytics-->AWS Glue --> Crawlers
  i) A crawler connects to a data store,
     progresses through a prioritized list of classifiers to determine the schema for your data,
      ( A classifier determines the schema of your data. You can use the AWS Glue built-in classifiers or write your own. )
     and then creates metadata tables in your data catalog.
     adds a table to the Glue Data Catalog with automatics columns/schema identified

1. Data-Crawler
  s3 input csv --> input-data-crawler --> Glue Data Catalog

2. ETL Job
  Job Prop | Datasource | transform type | data target | schema

3. ATHENA ( SQL on paraquet/csv/tsv files when their data catalogs are generated via Glue )
     Create table via
        i) Glue Crawlers
        ii) S3 bucket data directly without using glue.
      iii) Athena Query Results location --> configure to S3


s3://aws-glue-athena-lab-4i9m4aft/athena-results/

============================================================================================
Create a WebSocket API Using Amazon API Gateway


The route selection expression is used to determine how a request should be handled. In a normal REST based HTTP API, this would be done based on the URL path. In a WebSocket API, a connection has already been established, so the routing must be done based on a part of the request body. It takes the form of a JSON path to select an attribute of the body. ($request.body.{path_to_element})

Using API Gateway WebSocket APIs is a great way to allow your web application to update live without the need to constantly poll for changes. In this example, all the server events were triggered by events sent from the client, however events can be sent from anywhere; not just the Lambda which handles incoming events. This allows for a lot of flexibility when compared with a traditional WebSocket server.


=================================================================

AWS AppSync [Realtime + Responsive + API + Cache() + Offline Data uninterrupted + Lambda ]

============= Contributor Insights for Most accessedkeys and throttles in Dynamo DB =========
CloudWatch Contributor Insights for DynamoDB is a diagnostic tool for identifying the most frequently accessed and throttled keys in your table at a glance

Most Accessed Items (Partition Key)
Most Throttled Items (Partition Key)

DynamoDB triggers connect DynamoDB streams to Lambda functions. Whenever an item in the table is modified, a new stream record is written, which in turn triggers the Lambda function and causes it to execute

Point-in-time Recovery
DynamoDB maintains continuous backups of your table for the last 35 days.


Amazon Kinesis data stream details
Amazon Kinesis Data Streams for DynamoDB captures item-level changes in your table, and replicates the changes to a Kinesis data stream. You then can consume and manage the change information from Kinesis. Charges apply.

DynamoDB stream details
Capture item-level changes in your table, and push the changes to a DynamoDB stream. You then can access the change information through the DynamoDB Streams API.

======= RDS ====

RDS
======
1. Engine Choice + Engine Version  = Aurora | Mysql | Maria | PostgreSQl | Oracle | MS SQL
2. Credentials
3. DB Instance ~= Instance Type ( vcpu / Ram / Network )
          Standard Class / Memory Optimized / Burstable
4. Storage Type ( gp / io1 / magnetic )  / Provisioned IOPS
5. Enable Storage Auto scaling ( X GB)
6. Availability : Standby in a different AZ of same region.
            synchronous standby replica
   For Aurora -> Replica / Reader node in diff AZ for scaled availability

7. Connectivity : VPC / subnet group / public access etc
8. Automated Backups (Point in Time ) + Backup retention period ( <=35 days )
9. Encryption - AWS KMS Key
10. Enhanced Monitoring = 1 second interval.
11. Log Export to CloudWatch
12. Maintenance - Enable auto minor version update.
13. Deletion Protection.

14. Event Subscription - Target Notifications to
    i) ARN  = ONLY SNS
    ii) New Email topic

 From SNS -- Kinesis Data Firehose | SQS | Lambda | Email | Http | SMS

Failover ( RDS )

The failover mechanism automatically changes the Domain Name System (DNS) record of the DB instance to point to the standby DB instance. As a result, you need to re-establish any existing connections to your DB instance. In a Java virtual machine (JVM) environment, due to how the Java DNS caching mechanism works, you might need to reconfigure JVM settings.
The JVM caches DNS name lookups. When the JVM resolves a hostname to an IP address, it caches the IP address for a specified period of time, known as the time-to-live (TTL).

