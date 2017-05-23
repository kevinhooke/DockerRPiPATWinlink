#
# Builds a Docker Container for the Pat Winlink client

# Kevin Hooke, May 2017 @kevinhooke
#
FROM rpi-ax25

ARG MYCALL
RUN test -n "$MYCALL"

ARG MYCALLSSID
RUN test -n "$MYCALLSSID"

ARG MYLOC
RUN test -n "$MYLOC"

ARG WINLINKPASS
RUN test -n "$WINLINKPASS"

USER root

RUN apt-get update && \
    apt-get install wget
RUN wget https://github.com/la5nta/pat/releases/download/v0.2.4/pat_0.2.4_linux_armhf.deb
RUN dpkg -i pat_0.2.4_linux_armhf.deb

RUN mkdir -p /home/pi/.wl2k
COPY config.json /home/pi/.wl2k/
RUN chown pi:pi /home/pi/.wl2k/ && \
   chown pi:pi /home/pi/.wl2k/config.json

RUN mkdir -p /etc/ax25 && \
    echo "1 $MYCALLSSID 19200 255 3 TNCPi" > /etc/ax25/axports

RUN sed -i "s/MYCALL/$MYCALL/g" /home/pi/.wl2k/config.json
RUN sed -i "s/MYLOC/$MYLOC/g" /home/pi/.wl2k/config.json
RUN sed -i "s/WINLINKPASS/$WINLINKPASS/g" /home/pi/.wl2k/config.json
RUN sed -i "s/MYCALLSSID/$MYCALLSSID/g" /home/pi/.wl2k/config.json

USER pi
WORKDIR /home/pi


CMD ["pat", "http"]
