FROM ubuntu:15.10
MAINTAINER Selenium <selenium-developers@googlegroups.com>

#========================
# Miscellaneous packages
# Includes minimal runtime used for executing non GUI Java programs
#========================
RUN apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    ca-certificates \
    openjdk-8-jre-headless \
    sudo \
    unzip \
    wget \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/securerandom\.source=file:\/dev\/random/securerandom\.source=file:\/dev\/urandom/' ./usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security

#=====================================
# Install Ruby and other dependencies
#=====================================
RUN apt-get update -qqy \
  && apt-get install \
    gcc \
    ruby \
    ruby-dev \
    vim \
    git \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    make -qqy
RUN gem install bundle

#========================
# Download Jenkins Swarm
#========================
RUN mkdir /opt/bin
RUN wget http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/2.0/swarm-client-2.0-jar-with-dependencies.jar
COPY entry_point.sh /opt/bin/entry_point.sh
RUN chmod +x /opt/bin/entry_point.sh

CMD ["/opt/bin/entry_point.sh"]
