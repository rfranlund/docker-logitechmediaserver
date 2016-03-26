FROM debian:8

MAINTAINER Robert Frånlund <robert.franlund@poweruser.se>

ENV DEBIAN_FRONTEND noninteractive
ENV CURRENT_VERSION logitechmediaserver_7.9.0~1458661067_all.deb

# Update system and install dependencies
RUN apt-get update && \
  apt-get -y dist-upgrade && \
  apt-get -y install wget perl supervisor

# Fetch and install Logitech Media Server
RUN wget -O /tmp/logitechmediaserver.deb \
    $(wget -q -O - "http://www.mysqueezebox.com/update/?version=7.9.0&revision=1&geturl=1&os=deb") && \
  dpkg --install /tmp/logitechmediaserver.deb

# File system fixes
RUN rm -rf /tmp/logitechmediaserver.deb && \
  mkdir -p /config /var/log/supervisor

# Add start script
COPY assets/logitechmediaserver.conf /etc/supervisor/conf.d/logitechmediaserver.conf

# Container data volume 
VOLUME ["/config"]
WORKDIR /config

# Expose ports
EXPOSE 3483/tcp 9000/tcp 9090/tcp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
