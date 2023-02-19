FROM python:3.8.12-slim-buster

WORKDIR /app

COPY ~/PolyBot/* /app

RUN pip install --no-cache-dir -r requirements.txt

COPY ~/token/.telegramToken /app

CMD ["python3", "bot.py"]
