FROM ubuntu:latest

RUN apt-get update && apt-get install -y nginx

copy /nginx.html /usr/share/nginx/html/index.html

COPY /nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]