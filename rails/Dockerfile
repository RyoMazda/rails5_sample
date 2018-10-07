FROM ruby:2.5
ENV LANG C.UTF-8
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y vim

ENV APP_ROOT /rails
WORKDIR ${APP_ROOT}

# Add your custom installation here
# e.g. RUN apt-get install pigimaru

# bundle install
COPY Gemfile ${APP_ROOT}/
COPY Gemfile.lock ${APP_ROOT}/
RUN bundle install

# COPY project
COPY . ${APP_ROOT}/

CMD rails s