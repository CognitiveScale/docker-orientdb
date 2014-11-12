# c12e/orientdb

FROM c12e/debian
MAINTAINER CongnitiveScale (bill@c12e.com)

# Update repositry source list and install OrientDB dependencies
RUN apt-get update && \
   apt-get install -y supervisor git ant

# supervisord
ADD orientdb_supervisor.conf /etc/supervisor/supervisord.conf

# Build OrientDB cleaning up afterwards
RUN cd && \
    git clone https://github.com/orientechnologies/orientdb.git \
      --single-branch --depth 1 --branch 1.7.9 && \
    cd orientdb && \
    ant clean installg && \
    mv /releases/orientdb-community-* /opt/orientdb && \
    rm -rf /opt/orientdb/databases/* ~/orientdb

# Ports
EXPOSE 2424
EXPOSE 2480

# Set the user to run OrientDB daemon
USER root

# Default command when starting the container
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
