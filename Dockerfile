FROM ruby:2.5.1

# リポジトリを更新し依存モジュールをインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# ルート直下にtodo2という名前で作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /todo2
WORKDIR /todo2

## nodejsとyarnはwebpackをインストールする際に必要
# Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
apt-get install -y nodejs

# yarnパッケージ管理ツール
RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

ENV APP_HOME /todo2

# ホストのGemfileとGemfile.lockをコンテナにコピー
ADD Gemfile /todo2/Gemfile
ADD Gemfile.lock /todo2/Gemfile.lock

# bundle installの実行
RUN bundle install


# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
ADD . /todo2

CMD ["rails", "server", "-b", "0.0.0.0"]

#FROM ruby:2.5
#RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

#RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
#  && apt-get install -y nodejs

#RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
#apt-get update && apt-get install -y yarn

#RUN mkdir /mytodo2
#WORKDIR /mytodo2
#COPY Gemfile /mytodo2/Gemfile
#COPY Gemfile.lock /mytodo2/Gemfile.lock
#RUN bundle install
#COPY . /mytodo2




