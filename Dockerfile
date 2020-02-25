FROM ruby:2.5.7

ENV APP_PATH /app/

WORKDIR $APP_PATH

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list  \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get update -qqy \
    && apt-get install -y --no-install-recommends nodejs yarn \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Add codebase
ADD . $APP_PATH

# Install gems
ADD lcms-engine.gemspec $APP_PATH
ADD Gemfile* $APP_PATH
RUN gem install bundler -v 1.17.3 \
    && bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# Install yarn packages
COPY package.json yarn.lock $APP_PATH
RUN yarn install
