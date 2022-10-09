FROM openjdk:11
COPY full-app.jar .
EXPOSE 8080
CMD java -jar full-app.jar