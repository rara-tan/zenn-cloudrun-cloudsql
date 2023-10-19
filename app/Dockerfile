
# nodeのイメージを取得
FROM node:14

# アプリケーションディレクトリを作成
WORKDIR /usr/src/app

# アプリケーションの依存関係をインストール
COPY package*.json ./

RUN npm install

# アプリケーションのソースをバンドル
COPY . .

# ポート8080で実行
EXPOSE 8080
CMD [ "node", "index.js" ]
