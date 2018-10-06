FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN apt-get install -y vim git

ENV WORKDIR /root/sample_project
WORKDIR ${WORKDIR}

# Add your custom installation here
# e.g. RUN apt-get install pigimaru

# bundle install
COPY sample_project/Gemfile ${WORKDIR}/
COPY sample_project/Gemfile.lock ${WORKDIR}/
RUN bundle install

# COPY project
COPY sample_project/ ${WORKDIR}/
CMD rails s