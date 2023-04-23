FROM ubuntu:latest

RUN yum update && yum install -y nginx

copy ./nginx.html /usr/share/nginx/html

#COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]