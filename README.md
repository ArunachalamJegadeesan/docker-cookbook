## docker-cookbook  

### Docker Commands:


```
arun-mac:docker-cookbook arunaja$ docker login
Authenticating with existing credentials...
Login Succeeded
```
`docker build -t arunaja/catalogservice .`

`docker push arunaja/catalogservice`


```
arun-mac:docker-cookbook arunaja$ docker images
REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
arunaja/bff                    latest              9e96ca05abca        5 hours ago         121MB
arunaja/catalogservice         latest              c59a967f156c        5 hours ago         140MB
arunaja/productcatalogwebapp   latest              ddc338750385        7 hours ago         128MB
openjdk                        8-jdk-alpine        3675b9f543c5        2 weeks ago         105MB
registry                       latest              177391bcf802        16 months ago       33.3MB

```

`docker network create --driver bridge aj_net `


#### Working set of containers, follow the conventions 
 
``` 
docker run -d -p 7070:7070 --name aj-catalogservice --network aj_net c59a967f156c
```

```
docker run -d -p 6060:6060 --name aj-bff --env catalog.service.endpoint.url=http://aj-catalogservice:7070/catalog  --network aj_net 9e96ca05abca
```
```
docker run -d -p 8080:8080 --name aj-product-catalog  --env bff.endpoint.url=http://aj-bff:6060/bff/catalog  --network aj_net ddc338750385
```

 

  `docker ps -q -f "label=app.name=BFF"`

`docker ps  -f  "name=aj-*" `

`docker exec -it aj-productcatalog bin/sh `
 
`eval $"docker ps -q -f 'name=aj-*'"`

`docker ps   -q -f  "name=aj-*" `

` docker container stop $(docker ps -q -f 'name=aj-*') `

` docker container start $(docker ps -a  -q -f 'name=aj-*') `


 ### Best Practises :
 
 `  1 . Always use naming conventions while naming the conatiner  , this helps filtering ` 
     
  ` 2.  Provide as much  as labels while creating image , this helps filtering `
  
  ` 3 . Use user provided networks while connecting more than one container `
    
  ` 4 . Always take back up of the gonfig.json in .docker folder in your home directory before connecting to different
        container registrys like docker-hub , gcp repo or aws .( sample config.json attached ) `
	
	5. ** Dont use _ in container name ** . This will fail. Recreating all containers  without ' _' .
   `
  
  
  
  #### Workouts 
  
  ```
 arun-mac:java-home arunaja$ docker network inspect aj_net
[
    {
        "Name": "aj_net",
        "Id": "71bb40c195eb0a207c22a0e755c87672d6daa82d4ba31478f81c13220fa379e4",
        "Created": "2019-04-24T13:27:04.742978436Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "316d55957844f01b494888fadc4f95b0692ad1878eafe601405c63d28907b159": {
                "Name": "aj-product-catalog",
                "EndpointID": "77b17de0080062b7548c2808a6d74414f7d7bbaf2173b5a595bd9d71b9320f7c",
                "MacAddress": "02:42:ac:12:00:04",
                "IPv4Address": "172.18.0.4/16",
                "IPv6Address": ""
            },
            "5322350904a76b235ec473c38a47d06e06397e13224b991acca0821e6cd04a67": {
                "Name": "aj-bff",
                "EndpointID": "e1087dd91e159aa5098e1a7b9af08698999ff02be2fd648062d05b5bc6008498",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
            "d1d85c378efd5b34b15b3b0a66659d9a73655ffc48bfd58ce7ec24e924fd03d6": {
                "Name": "aj-catalogservice",
                "EndpointID": "4f64aa71737ce77657fd15311bf9cac1a550344129d3559e40c02c7d81d0baf8",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

```
arun-mac:java-home arunaja$ docker exec -it aj-product-catalog /bin/sh
/deploy # ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
2: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN qlen 1
    link/ipip 0.0.0.0 brd 0.0.0.0
3: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN qlen 1
    link/tunnel6 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00 brd 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
19: eth0@if20: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP
    link/ether 02:42:ac:12:00:04 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.4/16 brd 172.18.255.255 scope global eth0
       valid_lft forever preferred_lft forever
/deploy #
       
```       
 ```
 /deploy # ping -c 2 aj_catalog_service
PING aj_catalog_service (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: seq=0 ttl=64 time=0.096 ms
64 bytes from 172.18.0.3: seq=1 ttl=64 time=0.151 ms

--- aj_catalog_service ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.096/0.123/0.151 ms

```
 
 
 ```
 
 arun-mac:.docker arunaja$ pwd
/Users/arunaja/.docker
arun-mac:.docker arunaja$ ls -ltr
total 16
-rw-r--r--@ 1 arunaja  staff   47 Sep 23  2018 daemon.json
-rw-r--r--@ 1 arunaja  staff  158 Apr 24 20:25 config.json
arun-mac:.docker arunaja$ cat config.json
{
	"auths": {
		"https://index.docker.io/v1/": {}
	},
	"HttpHeaders": {
		"User-Agent": "Docker-Client/18.06.1-ce (darwin)"
	},
	"credsStore": "osxkeychain"
}
```

 
 
