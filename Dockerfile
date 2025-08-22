FROM ruby:3.2
WORKDIR /app
COPY . /app/
RUN bundle install
CMD ["ruby", "app.rb"]
