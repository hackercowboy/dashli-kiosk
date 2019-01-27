FROM node:8-jessie-slim

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
  apt-utils \
  clang \
  fbset \
  libasound2-dev \
  libcap-dev \
  libcups2-dev \
  libdbus-1-dev \
  libexpat-dev \
  libgconf2-dev \
  libgnome-keyring-dev \
  libgtk-3-dev \
  libnotify-dev \
  libnss3-dev \
  libsmbclient \
  libssh-4 \
  libxcb-image0 \
  libxcb-util0 \
  libxss1 \
  libxtst-dev \
  xdg-utils \
  xorg \
  xserver-xorg-core \
  xserver-xorg-input-all \
  xserver-xorg-video-fbdev

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
