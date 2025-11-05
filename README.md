# Almena

Plataforma experimental para gestionar identificadores descentralizados apoyándose en una federación privada de nodos IPFS/Kubo, un servicio de auto-configuración y herramientas de observabilidad.

## Requisitos previos

- Docker 24+ y Docker Compose v2 habilitado (`docker compose`).
- Permisos para editar `/etc/hosts` local si necesitas exponer los servicios por nombre (usa el fichero `hosts` como referencia).
- Acceso a los archivos del repositorio para actualizar `ipfs/nginx/config/autoconf.json` con el `PeerID` real del nodo bootstrap.

## Arranque rápido faseado

1. **Configura nombres locales**  
   Añade las entradas del archivo `hosts` a tu `/etc/hosts` (Linux/macOS) o `C:\Windows\System32\drivers\etc\hosts`.

2. **Inicia el perfil `bootstrap`**  
   ```bash
   docker compose --profile bootstrap up -d
   docker compose --profile bootstrap ps
   ```
   Espera a que `autoconf-server` muestre salud ✅ y `ipfs-bootstrap` esté en ejecución.

3. **Obtén el `PeerID` del bootstrap**  
   ```bash
   docker compose --profile bootstrap exec ipfs-bootstrap ipfs id -f='<id>\n'
   ```
   Copia el identificador y actualiza el multiaddress en `ipfs/nginx/config/autoconf.json` dentro de la sección `Bootstrap`. Ejemplo:
   ```json
   "/dns4/ipfs-bootstrap/tcp/4001/p2p/<NUEVO_PEER_ID>"
   ```
   Guarda los cambios y, si editaste el fichero con contenedores activos, reinicia el bootstrap:
   ```bash
   docker compose --profile bootstrap restart ipfs-bootstrap autoconf-server
   ```

4. **Arranca los nodos Kubo**  
   Lanza uno o más perfiles de nodo una vez actualizado el bootstrap:
   ```bash
    # Un nodo
   docker compose --profile nodo1 up -d

   # Todos los nodos definidos
   docker compose --profile nodo up -d
   ```

5. **Despliega el clúster IPFS (opcional)**  
   Define `CLUSTER_SECRET` para asegurar la comunicación entre peers y ejecuta:
   ```bash
   CLUSTER_SECRET=<token> docker compose --profile cluster up -d
   ```

6. **Activa la monitorización (opcional)**  
   ```bash
   docker compose --profile monitor up -d
   ```
   - Prometheus: <http://localhost:9090>  
   - Grafana: <http://localhost:3000> (usuario/contraseña por defecto `admin`/`admin`)

## Documentación modular

- [Arquitectura general](docs/overview.md)
- [Servicio bootstrap y autoconfiguración](docs/bootstrap.md)
- [Nodos Kubo e interfaz WebUI](docs/nodes.md)
- [Clúster IPFS](docs/cluster.md)
- [Monitorización y métricas](docs/monitoring.md)
- [Resolución de incidencias](docs/troubleshooting.md)

## Estructura del repositorio

- `compose.yml`: definición de los servicios, perfiles y volúmenes Docker.
- `ipfs/scripts`: scripts de inicialización para bootstrap y nodos trabajadores.
- `ipfs/nginx/config/autoconf.json`: plantilla de auto-configuración consumida por los nodos.
- `grafana/`: configuración de Prometheus.
- `docs/`: documentación modular.

## Contribuir

1. Crea una rama descriptiva.
2. Sigue la convención de perfiles y scripts existentes.
3. Documenta cualquier cambio relevante actualizando los módulos en `docs/`.
4. Abre un pull request explicando el impacto en el despliegue y operación.
