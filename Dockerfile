FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    git \
    cron \
    tzdata \
    chromium-browser \
    chromium-chromedriver

RUN ln -fs /usr/share/zoneinfo/Europe/Istanbul /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN git clone https://github.com/zercsiz/magketBot.git /app

WORKDIR /app

RUN pip3 install -r requirements.txt

# Set up a cron job to run your Python script daily at a specified time (e.g., 12:00 PM)
# Replace "12:00" with your desired time
RUN echo "20 15 * * * python3 /app/main_headless.py >> /var/log/cron.log 2>&1" > /etc/cron.d/mycron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/mycron

# Apply the cron job to the cron service
RUN crontab /etc/cron.d/mycron

# Create the log file to be used by cron
RUN touch /var/log/cron.log

# Run the cron service in the foreground
CMD cron && tail -f /var/log/cron.log
