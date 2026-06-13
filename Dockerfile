FROM python:3.11-slim

WORKDIR /app

# Install system deps if needed (none for basic boto3)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Install the package
RUN pip install --no-cache-dir -e .

# Default command shows help
ENTRYPOINT ["idle-guard"]
CMD ["--help"]