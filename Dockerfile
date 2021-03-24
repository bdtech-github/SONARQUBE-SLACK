FROM sonarqube:latest
LABEL BDTech <bdtechcourses@gmail.com>
RUN apk add --no-cache curl tar bash procps

# Downloading and installing Maven
# 1- Define a constant with the version of maven you want to install
ARG MAVEN_VERSION=3.6.3         

# 2- Define a constant with the working directory
ARG USER_HOME_DIR="/root"

# 3- Define the SHA key to validate the maven download
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0

# 4- Define the URL where maven can be downloaded from
ARG BASE_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries

# 5- Create the directories, download maven, validate the download, install it, remove downloaded file and set links
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downlaoding maven" \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  \
  && echo "Checking download hash" \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# 6- Define environmental variables required by Maven, like Maven_Home directory and where the maven repo is located
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

# 7- Download Plugin
RUN echo "Downloading Slack Plugin" \
  && wget https://github.com/kogitant/sonar-slack-notifier-plugin/archive/refs/tags/2.1.2.tar.gz -P /opt/sonarqube/extensions/plugins \
  \
  && echo "Unpacking Slack Plugin" \
  && cd /opt/sonarqube/extensions/plugins && tar -xf 2.1.2.tar.gz \
  \
  && echo "Installing plugin" \
  && cd /opt/sonarqube/extensions/plugins/sonar-slack-notifier-plugin-2.1.2 && mvn clean package
  && cp /opt/sonarqube/extensions/plugins/sonar-slack-notifier-plugin-2.1.2/target/cks-slack-notifier-2.1.2.jar /opt/sonarqube/extensions/plugins/

