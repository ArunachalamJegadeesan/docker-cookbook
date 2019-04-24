## docker-cookbook  

### Docker Commands:


 ` docker run -d -p 8080:8080 --name aj_product_catalog --network aj_net ddc338750385 `

`docker ps  -f  "name=aj_*" `

`docker exec -it aj_product_catalog bin/sh `
 
`eval $"docker ps -q -f 'name=aj_*'"`

`docker ps   -q -f  "name=aj_*" `

` docker container stop $(docker ps -q -f 'name=aj_*') `

` docker container start $(docker ps -a  -q -f 'name=aj_*') `
 
 `docker network create --driver bridge aj_net `
 
 ### Best Practises :
 
 `  1 . Always use naming conventions while naming the conatiner  , this helps filtering ` 
     
  ` 2.  Provide as much  as labels while creating image , this helps filtering `
  
  ` 3 . Use user provided networks while connecting more than one container ` 
 
 
 
 
