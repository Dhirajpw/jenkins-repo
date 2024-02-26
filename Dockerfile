# Use the official Tomcat image from Docker Hub
FROM tomcat:latest

# Set the working directory inside the container
WORKDIR /usr/local/tomcat

# (Optional) Remove the default webapps directory
RUN rm -rf webapps/*

# Copy your WAR file into the webapps directory of Tomcat
COPY path/to/your/application.war webapps/

# (Optional) Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat when the container starts
CMD ["catalina.sh", "run"]
