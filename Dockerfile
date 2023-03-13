FROM ruby:2.7.7

ENV APP_PATH /app/
ENV LANG C.UTF-8

WORKDIR $APP_PATH

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list  \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get update -qqy \
    && apt-get install -y --no-install-recommends nodejs yarn \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Add codebase
COPY . $APP_PATH

# Install gems
RUN gem install bundler:2.4.8 \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# Install yarn packages
COPY package.json yarn.lock $APP_PATH
RUN yarn install
