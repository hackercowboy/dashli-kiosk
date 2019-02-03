FROM node:8-stretch-slim

RUN echo "deb http://deb.debian.org/debian testing non-free contrib main" >> /etc/apt/sources.list

RUN apt-get update

RUN apt-get -y --no-install-recommends install \ 
  libasound2 \
  libgconf2-dev \
  libgtk-3-dev \
  libgtkextra-dev \
  libnss3 \
  libx11-xcb-dev \
  libxss1 \
  libxtst-dev \
  xinit \
  xserver-xorg \
  xserver-xorg-video-fbdev

RUN apt-get -t testing -y --no-install-recommends install fonts-noto-color-emoji

RUN rm -rf /var/lib/apt/lists/*

RUN echo "#!/bin/bash" > /etc/X11/xinit/xserverrc \
  && echo "" >> /etc/X11/xinit/xserverrc \
  && echo 'exec /usr/bin/X -s 0 dpms -nocursor -nolisten tcp "$@"' >> /etc/X11/xinit/xserverrc

# Move to app dir
WORKDIR /usr/src/app

# Move package.json to filesystem
COPY package.json yarn.lock ./

# Install npm modules for the application
RUN yarn install && node_modules/.bin/electron-rebuild
RUN  rm -rf /tmp/* && node_modules/.bin/electron-rebuild

# Move app to filesystem
COPY ./ ./

## uncomment if you want systemd
ENV INITSYSTEM on

# Start app
CMD ["bash", "/usr/src/app/start.sh"]

