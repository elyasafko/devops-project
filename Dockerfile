FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

# Install dependencies
RUN python -m pip install --no-cache-dir -r requirements.txt

COPY . .

# Create a non-root user for security
RUN useradd -m myuser
USER myuser

# Document that the container listens on port 5000
EXPOSE 5000

# The command to run the process
CMD ["python", "src/app.py"]