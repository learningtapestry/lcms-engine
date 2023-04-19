FROM ruby:3.2

ENV APP_PATH /app/
ENV LANG C.UTF-8

WORKDIR $APP_PATH

RUN apt-get update -qqy \
    && apt-get install -y --no-install-recommends \
      build-essential \
      chromium-driver \
      postgresql-client-13 \
      shellcheck \
      tzdata \
    && rm -r /var/lib/apt/lists/* /var/cache/apt/*

# install specific wkhtmltopdf binary
RUN apt-get update -qqy \
    && WK_VERSION=0.12.6.1-2 \
    && ARCH=$(dpkg --print-architecture) \
    && CODENAME=$(. /etc/os-release; echo $VERSION_CODENAME) \
    && curl -LSfso wkhtmltopdf.deb https://github.com/wkhtmltopdf/packaging/releases/download/$WK_VERSION/wkhtmltox_$WK_VERSION.${CODENAME}_$ARCH.deb \
    && apt-get install -qy xfonts-75dpi xfonts-base ./wkhtmltopdf.deb \
    && rm wkhtmltopdf.deb \
    && rm -r /var/lib/apt/lists/* /var/cache/apt/*

# Add codebase
COPY . $APP_PATH

# Install gems
RUN gem update --system 3.4.12 \
    && gem install bundler:2.4.12 \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# install nvm & yarn & packages
COPY .nvmrc $APP_PATH
COPY package.json yarn.lock $APP_PATH

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 18.15
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN mkdir -p /usr/local/nvm \
    && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g yarn \
    && yarn install
