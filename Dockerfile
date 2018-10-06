FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get install -y vim

ENV APP_ROOT /sample_project
WORKDIR ${APP_ROOT}

# Add your custom installation here
# e.g. RUN apt-get install pigimaru

# bundle install
COPY sample_project/Gemfile ${APP_ROOT}/
COPY sample_project/Gemfile.lock ${APP_ROOT}/
RUN bundle install

# COPY project
COPY sample_project/ ${APP_ROOT}/

CMD rails s