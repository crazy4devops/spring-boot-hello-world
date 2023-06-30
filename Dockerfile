FROM openjdk:11
WORKDIR /myapp
COPY target/*.jar /myapp/app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/myapp/app.jar"]