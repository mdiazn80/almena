# Servicio bootstrap y autoconfiguración

El nodo bootstrap es la piedra angular de la red IPFS privada. Se ejecuta junto a un servidor Nginx que publica un fichero de autoconfiguración consumido por el resto de nodos Kubo.

## Archivos relevantes

- `compose.yml`: perfil `bootstrap` con los servicios `autoconf-server` e `ipfs-bootstrap`.
- `ipfs/nginx/config/autoconf.json`: plantilla con la lista de peers bootstrap y opciones de red.
- `ipfs/scripts/bootstrap/020-config.sh`: habilita la funcionalidad `AutoConf` dentro de Kubo para el nodo raíz.

## Pasos para inicializar el bootstrap

1. **Arrancar los contenedores**
   ```bash
   docker compose --profile bootstrap up -d
   docker compose --profile bootstrap ps
   ```
   Confirma que `autoconf-server` está `healthy` y `ipfs-bootstrap` figura como `running`.

2. **Obtener el `PeerID` real**
   ```bash
   docker compose --profile bootstrap exec ipfs-bootstrap ipfs id -f='<id>\n'
   ```
   Anota el identificador; cambia cada vez que el repositorio IPFS se inicializa desde cero.

3. **Actualizar el autoconf**
   Edita `ipfs/nginx/config/autoconf.json` y reemplaza el valor del multiaddress en el array `Bootstrap`:
   ```json
   "/dns4/ipfs-bootstrap/tcp/4001/p2p/<NUEVO_PEER_ID>"
   ```
   Puedes incluir múltiples nodos bootstrap si existieran.

4. **Recargar servicios**
   ```bash
   docker compose --profile bootstrap restart autoconf-server ipfs-bootstrap
   ```
   Esto asegura que el servidor publique la nueva configuración y que el nodo bootstrap utilice los ajustes definitivos.

## Consejos y buenas prácticas

- Guarda una copia del `PeerID` en un gestor seguro; será necesario para unir nuevos nodos a la red.
- El fichero `swarm.key` ubicado en `ipfs/secrets/swarm.key` define el identificador de la red privada. Comparte este archivo solo con nodos autorizados.
- El valor `AutoConf.RefreshInterval` determina la frecuencia con la que los nodos trabajadores consultan actualizaciones. Ajusta este parámetro si necesitas rotar peers con mayor agilidad.
- Si cambias el puerto mapeado del bootstrap, recuerda actualizar el multiaddress correspondiente en `autoconf.json`.
