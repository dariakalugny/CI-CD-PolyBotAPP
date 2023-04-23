FROM ubuntu:latest

RUN apt-get update && apt-get install -y nginx

copy ./*.html /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]