FROM ruby:2.1.5
RUN apt-get update -qq && apt-get install -y nodejs

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

#RUN gem install bundler

RUN bundle install --jobs 20 --retry 5

COPY . /app

#RUN bundle exec rake db:migrate RAILS_ENV=development
#RUN bundle exec rake db:seed
RUN find / -name postgresql_adapter.rb -exec sed -i 's/panic/warning/g' {} +
EXPOSE 3000
ENV DATABASE_URL=postgres://u6uvn8nrtv6279:p2b2e6903c033d7b086cf9997f4a570572d1637f9dd3204a8da061fc446f8b29a@ec2-3-227-123-24.compute-1.amazonaws.com:5432/dermiqqijkap5l
CMD ["rails", "server", "-b", "0.0.0.0"]