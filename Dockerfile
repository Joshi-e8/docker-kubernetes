#########################################
# -------- 1️⃣ Builder Stage -------- #
#########################################

# Use lightweight Python base image
FROM python:3.11-alpine AS builder

# Set working directory inside container
WORKDIR /app

# Copy only requirements first
# This improves Docker layer caching
COPY requirements.txt .

# Upgrade pip and install dependencies
# --prefix installs packages into /install directory
# This keeps runtime image clean later
RUN pip install --upgrade pip && \
    pip install --prefix=/install --no-cache-dir -r requirements.txt


#########################################
# -------- 2️⃣ Final Stage ----------- #
#########################################

# Start from a fresh clean Python image
FROM python:3.11-alpine

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Ensure logs are printed directly to console
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Copy installed Python packages from builder stage
# Only final installed packages are copied
# No build cache, no temporary files
COPY --from=builder /install /usr/local

# Copy application source code
COPY . .

# Make entrypoint executable
RUN chmod +x entrypoint.sh migrate.sh

# (Optional but recommended) Create non-root user
RUN adduser -D appuser
RUN chown -R appuser /app
# Switch to non-root user for security
USER appuser

# Default command when container starts
CMD ["./entrypoint.sh"]