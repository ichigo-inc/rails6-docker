FROM node:16.14.2 as node
FROM ruby:2.7.4

RUN apt-get update -qq && apt-get install -y default-mysql-client && \
    apt-get install -y locales

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

ENV YARN_VERSION 1.22.18

COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/

RUN ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarnpkg /usr/local/bin/yarnpkg

ENV BUNDLER_VERSION 2.3.16

RUN gem install bundler -v $BUNDLER_VERSION

RUN mkdir -p /var/www/app
WORKDIR /var/www/app

# Add a script to be executed every time the container starts.
COPY ./docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Change timezone to JST
RUN apt-get install -y tzdata \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
# Remove caches
RUN rm -rf /var/lib/apt/lists/*
EXPOSE 3000