# Use the official Python image as a base
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONUNBUFFERED=1 \
    CELERY_UID=1000 \
    CELERY_GID=1000

# Create a non-root user for Celery
RUN groupadd --gid $CELERY_GID celery && \
    useradd --uid $CELERY_UID --gid $CELERY_GID --no-create-home --shell /bin/false celery


# Set the working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . /app/

# Change ownership to the celery user
RUN chown -R celery:celery /app

# Switch to the non-root user
USER celery

# Expose the application port
EXPOSE 8080

# Start Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "Finksta.wsgi:application"]
