FROM octopusdeploy/randomquotesjavabuild AS build-env
WORKDIR /app

# Copy pom and get dependencies as seperate layers
COPY pom.xml ./
RUN mvn dependency:resolve

# Copy everything else and build
COPY . ./
RUN mvn package -DfinalName=app

FROM tomcat:8.0

# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat
COPY --from=build-env /app/target/app.war /usr/local/tomcat/webapps/
