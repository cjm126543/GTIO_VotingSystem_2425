FROM node:22.14.0

WORKDIR /app

COPY . .

RUN npm install -g @angular/cli@19.2.1 typescript@5.4.5

RUN npm install

EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0"]
