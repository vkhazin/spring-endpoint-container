FROM  frekele/gradle:4.3.1-jdk8

COPY src /app/src
ADD build.gradle /app/build.gradle

WORKDIR /app
RUN gradle build -x test
RUN ls -a -l build/libs
RUN mkdir out
RUN for f in build/libs/*.jar; do cp "$f" out/app.jar; done

FROM openjdk:jre-alpine
VOLUME /tmp
LABEL version="0.1.0"
LABEL maintainer="vladimir.khazin@icssolutions.ca"

# some env settings
#ENV JAVA_OPTS="-Xmx512m"
#ENV SPRING_PROFILES_ACTIVE="release"

EXPOSE 8081
HEALTHCHECK NONE

COPY --from=0 '/app/out/app.jar' app/app.jar

RUN apk update && apk add bash
RUN mkdir /logs && ln -sf /dev/stdout /logs/app.log

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/app.jar"]