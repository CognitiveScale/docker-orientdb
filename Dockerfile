############################################################
# Dockerfile to run an OrientDB (Graph) Container
############################################################

FROM c12e/debian
MAINTAINER CognitiveScale (bill@cognitivescale.com)

# Update the default application repository sources list
RUN apt-get update

# Install supervisord
RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor

# Install OrientDB dependencies
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps
RUN apt-get -y install git ant

ENV ORIENTDB_VERSION 2.0-M2

# Build OrientDB cleaning up afterwards
RUN cd  && \
    git clone https://github.com/orientechnologies/orientdb.git --single-branch --depth 1 --branch $ORIENTDB_VERSION && \
    cd orientdb && \
    ant clean installg && \
    mv ~/releases/orientdb-community-* /opt/orientdb && \
    rm -rf /opt/orientdb/databases/* ~/orientdb

# use supervisord to start orientdb
ADD supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 2424
EXPOSE 2480

# Set the user to run OrientDB daemon
USER root

# Default command when starting the container
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
