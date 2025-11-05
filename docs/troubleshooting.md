# Resolución de incidencias

Esta guía recoge problemas habituales durante el despliegue faseado y cómo solucionarlos.

## El nodo no descubre peers

- Revisa que el fichero `ipfs/nginx/config/autoconf.json` contenga el `PeerID` correcto del bootstrap.
- Valida que `swarm.key` sea idéntico en todos los nodos (montado en `/data/ipfs/swarm.key`).
- Comprueba conectividad:
  ```bash
  docker compose exec ipfs-node1 ipfs swarm peers
  ```

## Errores al descargar la WebUI

- El script `010-webui.sh` omite la descarga si ya existe el archivo `./tmp/ipfs-webui.car`. Elimina esa carpeta dentro del volumen del contenedor si necesitas forzar una actualización.
- Verifica que `IPFS_WEBUI_VERSION` corresponda a una versión publicada en GitHub.

## Fallos de salud en `autoconf-server`

- Examina los logs:
  ```bash
  docker compose --profile bootstrap logs -f autoconf-server
  ```
- Asegúrate de que `ipfs/nginx/config/autoconf.json` es JSON válido. Puedes validarlo con `jq`:
  ```bash
  jq empty ipfs/nginx/config/autoconf.json
  ```

## El clúster no arranca

- Confirma que la variable `CLUSTER_SECRET` está definida al ejecutar `docker compose`.
- Comprueba la conectividad con el nodo IPFS subyacente:
  ```bash
  docker compose --profile cluster exec ipfs-cluster1 ipfs-cluster-ctl status
  ```
- Revisa los logs para mensajes de error de multiaddress:
  ```bash
  docker compose --profile cluster logs -f ipfs-cluster1
  ```

## Limpiar el entorno

- Para detener todos los servicios activos:
  ```bash
  docker compose down
  ```
- Los volúmenes persisten por defecto. Si necesitas reiniciar la red desde cero (perderás datos):
  ```bash
  docker compose down -v
  ```
  **Atención**: esto genera nuevos `PeerID`, por lo que deberás repetir el proceso de actualización de `autoconf.json`.
