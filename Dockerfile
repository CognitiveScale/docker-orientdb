############################################################
# Dockerfile to run an OrientDB (Graph) Container
############################################################

ENV ORIENTDB_VERSION 2.0-M2

FROM c12e/debian
MAINTAINER CognitiveScale (bill@cognitivescale.com)

# Update the default application repository sources list
# and Install OrientDB dependencies and supervisor
RUN apt-get update && \
    apt-get -y install git ant maven supervisor apt-utils

# Build OrientDB cleaning up afterwards
RUN mkdir /tmp/build && \
    cd /tmp/build  && \
    git clone https://github.com/orientechnologies/orientdb.git \
      --single-branch --depth 1 --branch $ORIENTDB_VERSION && \
    git clone https://github.com/orientechnologies/orientdb-lucene.git && \
    cd orientdb && \
    ant clean installg && \
    cd ../orientdb-lucene && \
    mvn assembly:assembly && \
    mv /tmp/build/releases/orientdb-community-${ORIENTDB_VERSION} /opt && \
    mv /tmp/build//orientdb-lucene/target/orientdb-lucene-${ORIENTDB_VERSION}-dist.jar \
      /opt/orientdb-community-${ORIENTDB_VERSION}/plugins && \
    rm -rf /opt/orientdb-community-${ORIENTDB_VERSION}/databases/* && \
    rm -rf  /tmp/build ~/.m2 && \
    mkdir -p /var/log/supervisor /data /logs && \
    ln -s /opt/orientdb-${ORIENTDB_VERSION} /opt/orientdb 

# use supervisord to start orientdb
ADD supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 2424
EXPOSE 2480

# Set the user to run OrientDB daemon
USER root

# Default command when starting the container
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
