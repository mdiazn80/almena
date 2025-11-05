# Monitorización y métricas

El perfil `monitor` activa Prometheus y Grafana para recolectar y visualizar métricas de los nodos IPFS y del clúster.

## Prometheus

- Servicio definido como `prometheus` en `compose.yml`.
- Monta la configuración desde `grafana/prometheus.yml`.
- Expone la interfaz en <http://localhost:9090>.
- Persiste datos en el volumen `prometheus-data`.

### Endpoints preconfigurados

Ajusta `grafana/prometheus.yml` si añades nuevos objetivos (scrape targets). Por defecto, se espera que los servicios de clúster expongan métricas en `:8888`.

## Grafana

- Servicio `grafana`, también en el perfil `monitor`.
- Puesto disponible en <http://localhost:3000>.
- Credenciales por defecto configuradas vía variables de entorno: `admin` / `admin`.
- Los dashboards y configuraciones se almacenan en el volumen `grafana-data`.

### Primeros pasos

1. Inicia el perfil `monitor`:
   ```bash
   docker compose --profile monitor up -d
   ```
2. Accede a Grafana y crea un data source apuntando a `http://prometheus:9090`.
3. Importa o crea dashboards específicos para IPFS (por ejemplo, latencia de pinning, uso de memoria, peers conectados).

## Integración con otros módulos

- Los contenedores `ipfs-cluster1` e `ipfs-cluster2` exponen métricas Prometheus en el puerto 8888; asegúrate de que Prometheus tenga visibilidad de esos endpoints.
- Puedes extender la monitorización añadiendo exporters (p.ej. `node-exporter`) vinculados al mismo perfil para observar recursos de host.
