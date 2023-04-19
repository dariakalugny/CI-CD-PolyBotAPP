FROM ubuntu:latest

RUN apt-get update && apt-get install -y ngnix

CMD ["nginx", "-g", "daemon off;"]