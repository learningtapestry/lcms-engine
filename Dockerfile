FROM ruby:3.3.9

ENV APP_PATH=/app/
ENV LANG=C.UTF-8

WORKDIR $APP_PATH

RUN apt-get autoclean \
    && apt-get clean \
    && apt-get update -qqy \
    && apt-get install -y --no-install-recommends \
    build-essential \
    chromium-driver \
    postgresql-client \
    shellcheck \
    tzdata \
    && rm -r /var/lib/apt/lists/* /var/cache/apt/*

# Add codebase
COPY . $APP_PATH

# Install gems
ENV BUNDLER_VERSION=2.5.22
RUN gem install bundler:$BUNDLER_VERSION \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# install nvm & yarn & packages
COPY .nvmrc $APP_PATH
COPY package.json yarn.lock $APP_PATH

ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=18.15.0
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

SHELL ["/bin/bash", "--login", "-i", "-c"]
RUN mkdir -p /usr/local/nvm \
    && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm install -g yarn \
    && yarn install
