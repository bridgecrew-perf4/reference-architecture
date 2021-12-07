FROM adobecoldfusion/coldfusion2018:latest

# mysql connector is not distributed so we have to add it
COPY mysql-connector-java-8.0.25.jar /opt/coldfusion/cfusion/lib
RUN chmod 755 /opt/coldfusion/cfusion/lib/mysql-connector-java-8.0.25.jar
RUN chown cfuser:bin /opt/coldfusion/cfusion/lib/mysql-connector-java-8.0.25.jar

# website code
COPY ./app/* /app/
