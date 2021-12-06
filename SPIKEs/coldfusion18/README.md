# ColdFusion

## Getting Started

### Build

The container must be built before we can do anything and we will use docker-compose for this demonstration.

```
# pull containers from docker hub
docker-comose pull

# build our customized coldfusion image
docker-compose build

# or you can do both at the same time
docker-compose build --pull
```

### Run

Once containers have been pulled and images have been built then we can simply start the services.

```
# start the services
docker-compose up

# start the services and make sure the container is rebuilt when changes are detected
docker-compose up --build
```

### Testing MySQL connectivity

The services should now be running and we need to confirm that MySQL is running and accessible. The docker-compose does expose port 3306 on the host and will direct to the container on port 3306 so lets use `netcat` to make sure that MySQL can respond.

```
nc -z localhost 3306 && echo $? # should return 0
```

We must now access via a web browser the administrative area of our [coldfusion server](http://localhost/CFIDE/administrator/index.cfm) using the password `admin` to create a Data Source called `example` that will connect to the MySQL container/database. Navigate to the **Data & Services** area so that we can add a new **Data Source**.

To start this process you will need to enter the **Data Source Name** as `example` with a **Driver** of `MySQL` and click the **[Add]** button to configure the details of that connection.

**Database:** `coldfusion`

**Server:** `mysql`

**Port:** `3306`

**Username:** `cold`

**Password:** `fusion`

**[Submit]**

You should now be back at the list of **Connected Data Sources** and you should see our new source `example` in the list. If you click on the **Verify All Connections** the status of all connections should be **OK** and it is now time to visit the [homepage](http://localhost).

## References

### Documentation

- [https://www.quackit.com/coldfusion/tutorial/](https://www.quackit.com/coldfusion/tutorial/)
- [https://helpx.adobe.com/coldfusion/using/docker-images-coldfusion.html](https://helpx.adobe.com/coldfusion/using/docker-images-coldfusion.html)
- [https://www.codejava.net/java-se/jdbc/jdbc-driver-library-download](https://www.codejava.net/java-se/jdbc/jdbc-driver-library-download)


