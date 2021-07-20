# Route 53 ( DNS )

DNS mapping of domain with other details not just IP.

|Domain|Record Type|Value|
|---|---|---|
|satbasu.hosted.com|A (IP Address)|21.2.2.2|



### Nodes in a Domain NameSpace

Example hierarchy explained Each Node has a domain name  

> satbasu.hosted.com.   

|NODE -Tree Hierarchy | Domain Name of the Node| NameServer Zone|
|---|---|---|
|.|.|NS1|
|com|com.|NS2|
|hosted|hosted.com.|NS3|
|satbasu|satbasu.hosted.com.|NS3|

Each Name server is author for the zone it holds.

## Dividing Namespace and held by multiple NameServers + Query recursion
 1. Domain names Nodes handled by different entities rather than managing whole tree.  
 2. Each Name Server will have ONLY 1 part of the domain namespace.  
 
 Each Name Server holds different pieces.
 
|NameServer|Record Entry|
|---|---|
|NS2| ORIGIN com.|
|NS2| hosted.com. NS ns3|
|NS3|ORIGIN hosted.com.|
|NS3|satbasu.hosted.com A 21.2.2.2|

```
For a client the lookup is to reach the A record by jumping from NS reference starting from root.
Every client must know the root nameserver to perform this recursive search.
```

## Internet / Public Domain Namespace  

![EmbedImg](https://github.com/satadrubasu/aws-play/blob/main/route53/Route53-HostedZone.jpg?raw=true)

### 1. Route53 [ Policy - Failover ] - Health Checks

![EmbedImg](https://github.com/satadrubasu/aws-play/blob/main/route53/route53-failover.jpg?raw=true)


### 2. Route53 [ Policy - Weighted ] - Break 100

- Remember the TTL always comes to play !!
- Uneven weights - where serving hosts can have varying instance capacity
- If Health check fails on a record - Consider it as updated to weight-value as 0.


|Name|Record Type|Policy|Value |Target Value|
|---|---|---|---|---|
|web1-east.abc.com|A|Simple|-|172.11.1.11|
|web2-east.abc.com|A|Simple|-|172.11.1.12|
|web1-west.abc.com|A|Simple|-|172.12.1.11|
|web2-west.abc.com|A|Simple|-|172.12.1.12|
|www.abc.com|A|Weighted|25|web1-east.abc.com|
|www.abc.com|A|Weighted|25|web2-east.abc.com|
|www.abc.com|A|Weighted|25|web1-west.abc.com|
|www.abc.com|A|Weighted|25|web2-west.abc.com|

### 3. Route53 [ Policy - GeoLocation / Latency ] - Break 100  

While DNS Server follow the recursion logic , the calling location is matched against nearest Geolocation entry to resolve.  
 - Observe if a query goes from a geolocation that doesn't have a record entry it tries to lookup the default.
 - If no DEFAULT record and No Geo location match - not reachable !!    
 - https://www.whatsmydns.net/#NS/satadrubasu.net

|Name|Record Type|Policy|Value |Target Value|
|---|---|---|---|---|
|web1-east.abc.com|A|Simple|-|172.11.1.11|
|web2-east.abc.com|A|Simple|-|172.11.1.12|
|web1-west.abc.com|A|Simple|-|172.12.1.11|
|web2-west.abc.com|A|Simple|-|172.12.1.12|
|www.abc.com|A|Geolocation(USA)|USA|web1-east.abc.com|
|www.abc.com|A|Geolocation-(SC)|USA-SC|web2-east.abc.com|
|www.abc.com|A|Geolocation-(default)|default|web1-west.abc.com|

 * Latency policy works almost similarly, where the latency is calculated to the aws region.

### 4. Route53 [ Policy - Geoproximity ]
 - Configurable with diagram
 - Considers geo location region compared to nearest region , not necessarily in the region.

### 5. Route53 [ Policy - Multi Value ]
 
 - Same as simple policy A records , where single domain name will be returned with multiple values.
 - Only Difference being MultiValue has health check provision and won't return the IP thats not healthy. 



