FROM apache/airflow:2.9.1-python3.10

# Install OS-level packages if needed (e.g., gcc, curl, etc.)
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch to airflow user for remaining steps
USER airflow

# Optional: install custom Python dependencies
COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

# Optional: use custom airflow.cfg if needed
# COPY airflow.cfg /opt/airflow/airflow.cfg
