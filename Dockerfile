FROM nginx:latest
WORKDIR /var/www/app
COPY . .
EXPOSE 80
