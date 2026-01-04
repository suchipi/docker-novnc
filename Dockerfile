FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8

RUN set -ex; \
    apt-get update; \
    apt-get install -y \
      fluxbox \
      novnc \
      supervisor \
      tigervnc-common \
      tigervnc-standalone-server \
      xterm \
      expect \
      git

WORKDIR /root

# Replace noVNC frontend with newer version in order to get quality/compression support
RUN git clone https://github.com/novnc/noVNC.git && \
  cd noVNC && \
  git checkout v1.3.0 && \
  rm -rf /usr/share/novnc/app /usr/share/novnc/core /usr/share/novnc/vendor /usr/share/novnc/*.html && \
  cp -R ./app /usr/share/novnc/ && \
  cp -R ./core /usr/share/novnc/ && \
  cp -R ./vendor /usr/share/novnc/ && \
  cp -R ./vnc.html /usr/share/novnc/ && \
  cp -R ./vnc_lite.html /usr/share/novnc/ && \
  cd /usr/share/novnc && \
  ln -s vnc.html index.html

ENV HOME=/root \
    DISPLAY=:0.0 \
    DISPLAY_WIDTH=1024 \
    DISPLAY_HEIGHT=768

COPY . /vnc
ENTRYPOINT ["/vnc/entrypoint.tcl"]
EXPOSE 8080
