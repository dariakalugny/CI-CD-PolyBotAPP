#FROM python:3.8.12-slim-buster
FROM python:3.12.0a5-slim

WORKDIR /app

COPY . /app/

#COPY .telegramToken .telegramToken

RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["python3", "bot.py"]
