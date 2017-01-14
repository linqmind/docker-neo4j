# Docker neo4j


## Description
neo4j 3.1 版本的Docker镜像

## Usage
```
docker run \  
     --name db-neo4j \  
        -d \  
        -e NEO4J_AUTH=neo4j:demo001 \  
        --cap-add=SYS_RESOURCE \ 
        -p 22:22 -p 7474:7474 -p 7687:7687\
        -v /data/neo4j-data:/var/lib/neo4j/data \
        -v /data/neo4j-logs \
        registry.cn-hangzhou.aliyuncs.com/haibin/neo4j
```
使用参数说明:  
```
  - -- name 镜像名称  
  - -d 后端启动  
  - -e NEO4J_AUTH=<username>:<password>,username neo4j的登录的用户名，neo4j登录的密码。  
  - -p 向外暴露的接口， -p <output_port>:<input_port> output_port 外部服务器的访问端口，input_port 内部服务器的访问端口。  
  - -v 映射逻辑卷。 -v <output_volumn>:<input_volumn> output_volumn 外部逻辑卷，input_volumn 内部逻辑卷。  
  最后一行是需要启动镜像。  
```
