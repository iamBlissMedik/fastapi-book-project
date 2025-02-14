# Use the official Python image as the base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt /app/

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the FastAPI application code
COPY . /app

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Remove the default Nginx configuration file
RUN rm /etc/nginx/sites-enabled/default

# Copy your Nginx configuration file
COPY nginx.conf /etc/nginx/sites-available/fastapi
RUN ln -s /etc/nginx/sites-available/fastapi /etc/nginx/sites-enabled

# Expose the ports that Nginx and Uvicorn will use
EXPOSE 80 8000

# Start Nginx and Uvicorn
CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8000
