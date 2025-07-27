# ⏱️ Chronos Orchestrator

**Chronos Orchestrator** is a production-ready, distributed workflow orchestration platform powered by **Apache Airflow**. Designed to run on Docker, it manages and schedules DAG-based tasks, integrates monitoring, and supports scaling with Celery workers and Redis.

---

## 📐 Architecture Overview

```mermaid
graph TD
  A[NGINX (Reverse Proxy)] --> B[Airflow Webserver]
  B --> C[Scheduler]
  C --> D[Workers]
  D --> E[(DAGs/Tasks)]
  B --> F[(DAGs Volume)]
  D --> F
  C --> G[(Metadata DB - PostgreSQL)]
  D --> G
  G --> H[(Logs - Mounted Volume)]

---

## 📁 Repository Structure

```
chronos-orchestrator/
├── airflow/
│   ├── Dockerfile
│   ├── airflow.cfg
│   └── requirements.txt
│
├── nginx/
│   ├── Dockerfile
│   └── default.conf
│
├── dags/                     # Optional: local DAGs during development
│
├── .env
├── .env.template
├── docker-compose.yml
├── init.sh
└── start.sh
```

---

## ⚙️ Tech Stack

| Component     | Description                              |
|---------------|------------------------------------------|
| Apache Airflow| DAG orchestration engine                 |
| Redis         | Celery message broker                    |
| PostgreSQL    | Airflow metadata DB                      |
| Flower        | Celery task monitoring                   |
| NGINX         | Reverse proxy to Airflow webserver       |
| Docker Compose| Container orchestration tool             |

---

## 🚀 Getting Started

### 📦 Prerequisites

- Docker Desktop (for macOS)
- Homebrew (macOS package manager)
- `bash` or `zsh` shell

---

### 🧰 Step 1: Initialize Environment

```bash
./init.sh
```

- Verifies required tools
- Copies `.env.template` to `.env`
- Generates Fernet key for Airflow

---

### 🟢 Step 2: Start the Services

```bash
./start.sh
```

- Starts all containers via `docker-compose`

---

### 🌐 Step 3: Access Services

| Service        | URL                  | Notes                          |
|----------------|----------------------|--------------------------------|
| Airflow UI     | http://localhost     | Default: `admin / admin`      |
| Flower         | http://localhost:5555| Monitor Celery workers/tasks  |
| PostgreSQL     | localhost:5432       | Internal usage                 |

---

## 📂 Using an External DAGs Repository

Maintain DAGs separately:

```bash
~/dev/chronos-dags/
├── dags/
├── plugins/
└── conf/
```

Update your `docker-compose.yml` to mount this:

```yaml
volumes:
  - ~/dev/chronos-dags/dags:/opt/airflow/dags
  - ~/dev/chronos-dags/plugins:/opt/airflow/plugins
  - ~/dev/chronos-dags/conf:/opt/airflow/conf
```

---

## 🔐 Environment Configuration

Sample `.env` content:

```dotenv
AIRFLOW__CORE__EXECUTOR=CeleryExecutor
AIRFLOW__CORE__FERNET_KEY=<generated>
AIRFLOW__CORE__LOAD_EXAMPLES=False
AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION=True
AIRFLOW__WEBSERVER__SECRET_KEY=<generated>

AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@postgres:5432/airflow
AIRFLOW__CELERY__BROKER_URL=redis://redis:6379/0
AIRFLOW__CELERY__RESULT_BACKEND=db+postgresql://airflow:airflow@postgres:5432/airflow
```

---

## 🧪 Testing the Setup

```bash
# List available DAGs
docker exec -it airflow-scheduler airflow dags list

# List Airflow users
docker exec -it airflow-webserver airflow users list
```

---

## 🔍 Troubleshooting

| Issue                    | Solution                              |
|--------------------------|----------------------------------------|
| UI doesn't load          | Check NGINX port bindings              |
| DAGs not visible         | Ensure volume mounts are correct       |
| Workers not processing   | Use Flower to inspect Celery tasks     |
| Permission denied        | `chmod -R 755 dags/ plugins/ conf/`    |

---

## 📊 Monitoring

- View logs using:

```bash
docker logs airflow-webserver
docker logs airflow-scheduler
docker logs airflow-worker
```

- Visit Flower UI: [http://localhost:5555](http://localhost:5555)

---

## 🧩 Customization Tips

- Add Python packages to `airflow/requirements.txt`
- Modify `nginx/default.conf` to proxy custom paths
- Tune `airflow.cfg` for performance and security
- Add users via:
  ```bash
  docker exec -it airflow-webserver airflow users create ...
  ```

---

## 📘 License

MIT License © 2025 Dinesh Maharana

---

## 🙌 Contributions Welcome

- Found a bug? Open an issue
- Want to contribute? Send a PR
- Questions? Contact the maintainer

---

## 🛠 Built With

- [Apache Airflow](https://airflow.apache.org/)
- [Docker](https://www.docker.com/)
- [Flower](https://flower.readthedocs.io/)
- [NGINX](https://www.nginx.com/)

---

Happy Scheduling 🎯
