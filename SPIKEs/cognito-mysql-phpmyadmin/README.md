## Information

In this spike and as a proof of concept, we want use PHP as a web application connecting to a mysql db instance. We want to see if it is possible to incorporate a similar developer experience that we have with Certify & Postgres.

PHPAdmin can run as a web application behind cognito and will provide functionality to make the VPN useless.

### Configuration

The "docker-compose.yml" file is used here as the configuration file to define what containers/services are being provisioned. To start/stop services, the below commands can be used;

```
docker-compose up

docker-compose down
```

### Reference Docs
 
https://hub.docker.com/_/phpmyadmin 