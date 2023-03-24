#!/bin/bash

# Crear archivo /tmp/prometheus.yml
cat <<EOF > /tmp/prometheus.yml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'codelab-monitor'

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first.rules"
  # - "second.rules"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'docker'
         # metrics_path defaults to '/metrics'
         # scheme defaults to 'http'.

    static_configs:
      - targets: ['localhost:9323']
EOF

# Crear red de Docker para Prometheus y Grafana
sudo docker network create monitor-net

# Descargar imagen de Prometheus
sudo docker pull prom/prometheus

# Crear contenedor de Prometheus
sudo docker run -d --name=prometheus --network monitor-net -p 9090:9090 -v /tmp/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

# Descargar imagen de Grafana
sudo docker pull grafana/grafana

# Crear contenedor de Grafana
sudo docker run -d --name=grafana --network monitor-net -p 3000:3000 grafana/grafana-oss
