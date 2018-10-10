FROM ruby:2.5
ENV LANG C.UTF-8
RUN apt-get update -qq &&\
    apt-get install -y build-essential libpq-dev nodejs vim

ENV APP_ROOT /rails
WORKDIR ${APP_ROOT}

# Add your custom installation here
# e.g. RUN apt-get install pigimaru

# bundle install
COPY rails/Gemfile ${APP_ROOT}/
COPY rails/Gemfile.lock ${APP_ROOT}/
RUN bundle install

# COPY project
COPY rails/ ${APP_ROOT}/

EXPOSE 3000

# VOLUME ${APP_ROOT}/public
# VOLUME ${APP_ROOT}/tmp

CMD rails s