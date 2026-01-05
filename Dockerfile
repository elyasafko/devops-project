# Use a slim base image to reduce attack surface and size (Alpine is smaller, but Slim is more compatible)
FROM python:3.9-slim

# Set working directory inside the container process
WORKDIR /app

# Copy only requirements first to leverage Docker Layer Caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create a non-root user for security (Important for interview!)
RUN useradd -m myuser
USER myuser

# Document that the container listens on port 5000
EXPOSE 5000

# The command to run the process
CMD ["python", "app.py"]