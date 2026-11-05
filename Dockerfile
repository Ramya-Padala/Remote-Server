FROM nginx:latest
WORKDIR /var/www/html/index.html
COPY . .
EXPOSE 80
