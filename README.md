# Spring Endpoint CD with Jenkins and Docker on Amazon

### Overview
This is proof of concept project showing implementation of CI/CD enviromnet for building a RESTful Web Service with [Spring Framework](https://en.wikipedia.org/wiki/Spring_Framework). The project uses following components to automate build process:
* [Jenkins](https://en.wikipedia.org/wiki/Jenkins_(software))
* [Docker](https://en.wikipedia.org/wiki/Docker_(software))
* [Gradle](https://en.wikipedia.org/wiki/Gradle)

The project uses modified version of [Spring Framework "Hello World" example for RESTful Web Service](https://spring.io/guides/gs/actuator-service/).

### Jenkins, NginX and Docker installation and configuration on Amazon Linux AMI
* Login into vanilla instance of Amazon Linux AMI 2017.09
* Install git:
```
sudo yum install -y git
```
* Clone the repo and specify branch to be checked out:
```
git clone -b ned.radev/initial_working_branch https://bitbucket.org/vedarn/spring-endpoint-container.git
```
* Execute following script which will install and configure NginX, Jenkins and Docker:
```
cd spring-endpoint-container
sh jenkins/setup_jenkins_ami_linux.sh
```
* After installation login using https://public-ip-address with password listed at the end of setup script
* You can skip start-up window, all of the needed plugins are installed already

### Why NginX?
* Jenkins is not as easy to configure to use encryption: https://wiki.jenkins-ci.org/display/JENKINS/Starting+and+Accessing+Jenkins
* NginX reverse proxy is somewhat easier to setup and to encrypt traffic to Jenkins
* See [nginx.sh](https://bitbucket.org/vedarn/spring-endpoint-container/src/7e05e60337e3e715f4d7ec65bc91b99a50d4f2f3/jenkins/nginx.sh?at=ned.radev%2Finitial_working_branch) for details

# Project Setup
* After skipping the setup wizard an empty dashboard is presented:
![alt text](./screen-capture/no-projects.png "Empty Jenkins Dashboard")
* Select 'create new jobs' link
* Enter project name and select 'Pipeline Project':
![alt text](./screen-capture/project-name.png "Project name")
* Select 'Ok' to continue
* On the project configuration page scroll down to 'Pipeline' and from 'Definition' drop-down list select 'Pipeline script from SCM' option.
* From newly-appeared drop-down list 'SCM' select 'Git' option
* Paste repository URL in 'Repository URL' text box: https://bitbucket.org/vedarn/spring-endpoint-container.git and configure credentials if applicable
* Paste repository branch in 'Branch specifier' text box:
```
ned.radev/initial_working_branch
```
* Select 'Save' button and you should be redirected to project dashboard
* On the left hand select 'Build now' link to trigger a new build
* A build progress indicator should appear. The first build may fail. Refresh the job page, now 'Build now' link should have become 'Build with parameters'. Click it.
* New page appears where build requieres input value for parameter 'GIT_BRANCH'. Paste following branch and click on Build button:
```
ned.radev/initial_working_branch
```
* You should be redirected to job dashboard. Select the build number and then select 'Console Output' on the left hand:
![alt text](./screen-capture/build-output.png "Build Output")
* If all is in order the last few lines should look like:
```
[Pipeline] End of Pipeline
Finished: SUCCESS
```
# Jenkinsfile
Jenkins pipeline build relies on pre-created file in source repo, ususally it is named Jenkinsfile (name could be customized). It contains Groovy based DSL script. See more details in project's [Jenkinsfile](https://bitbucket.org/vedarn/spring-endpoint-container/src/7e05e60337e3e715f4d7ec65bc91b99a50d4f2f3/Jenkinsfile?at=ned.radev%2Finitial_working_branch).

# Docker and Gradle
Build delivery is a Docker image containng a JAR file built also in a Docker container. The JAR file is built using one of the official Gradle docker images 'gradle:4.5.1-jdk8-alpine'. It is pulled during build execution. After a successful build of the JAR file it is packed in a new Docker image based on 'openjdk:jre-alpine' (Alpine Linux with JRE).
# Starting RESTful Web Service wuth docker
* Execute
```
docker pull vkhazin:spring-endpoint-container
docker run -p 9000:9000 vkhazin:spring-endpoint-container java -jar /app.jar
```
* Check what it returns with:
```
curl http://localhost:9000/hello-world
```
* It should return
```
{"message":"Hello World"}
```
