# Nodos Kubo e interfaz WebUI

Los perfiles `nodo1`, `nodo2` y `nodo` en `compose.yml` inician contenedores IPFS/Kubo que se conectan al nodo bootstrap y, opcionalmente, exponen la WebUI.

## Perfiles disponibles

- `nodo1`: instancia de referencia que publica los puertos 8081 (gateway), 4001 (swarm) y 5001 (API).
- `nodo2`: segunda instancia con puertos desplazados (8181, 4101, 5101) y comando `daemon --migrate=true`.
- `nodo`: perfil compuesto que levanta todos los nodos definidos.

## Variables de entorno clave

- `IPFS_WEBUI_PORT`: puerto local desde el que se servirá la WebUI.
- `IPFS_WEBUI_VERSION`: versión de la interfaz que se descargará en el arranque.

Estas variables se utilizan en los scripts de inicialización montados en `/container-init.d/`.

## Scripts asociados

1. **`ipfs/scripts/worker/010-webui.sh`**  
   - Comprueba si ya existe `./tmp/ipfs-webui.car` dentro del contenedor.  
   - Si no, descarga el paquete `.car` de GitHub y lo importa con `ipfs dag import`, añadiendo la WebUI al repositorio local.

2. **`ipfs/scripts/worker/020-config.sh`**  
   - Deshabilita la funcionalidad `AutoConf` (los nodos trabajadores se configuran de forma estática).  
   - Habilita cabeceras CORS para permitir que la WebUI acceda a la API.  
   - Limpia bootstrapers por defecto (`ipfs bootstrap rm --all`) para forzar el uso del nodo raíz configurado en `autoconf.json`.

## Arranque de nodos

1. Asegúrate de que `autoconf.json` contiene el `PeerID` actualizado del bootstrap.
2. Lanza el perfil deseado:
   ```bash
   docker compose --profile nodo1 up -d
   # o
   docker compose --profile nodo2 up -d
   # o ambos
   docker compose --profile nodo up -d
   ```
3. Comprueba estado y direcciones multiaddress:
   ```bash
   docker compose --profile nodo exec ipfs-node1 ipfs id
   ```

## Acceso a la WebUI

- Nodo 1: <http://localhost:5001/webui>  
- Nodo 2: <http://localhost:5101/webui>

Si usas nombres definidos en el fichero `hosts`, también puedes acceder mediante `http://ipfs-node1:5001/webui`.

## Persistencia y mantenimiento

- Los volúmenes `ipfs-node*-data` almacenan el repositorio IPFS; no se borran al recrear el contenedor.
- El volumen `ipfs-node*-export` permite montar archivos a compartir. Sube contenidos con `ipfs add` o `ipfs dag import` según el flujo de trabajo.
- Usa `docker compose logs -f ipfs-node1` para depurar errores en el arranque o validación del `swarm.key`.
