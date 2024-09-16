FROM ruby:bookworm

RUN gem install rails -v 7.2.1 && mkdir watchman

WORKDIR /watchman

COPY Gemfile* .

RUN bundle install

RUN gem install turbo-rails -v 2.0.6
RUN gem install jbuilder -v 2.12.0

COPY . .

EXPOSE 3000

CMD ["bin/rails", "s", "-b", "0.0.0.0", "-p", "3000"]