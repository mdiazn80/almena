# Arquitectura general

Este proyecto describe un entorno local y reproducible para operar una red privada de IPFS orientada a identificadores descentralizados. Los servicios se orquestan mediante perfiles de Docker Compose, lo que permite activar únicamente los módulos necesarios en cada fase.

## Componentes principales

- **Autoconf server (`autoconf-server`)**: expone el fichero `autoconf.json` vía HTTP. Los nodos Kubo lo consultan para obtener la lista de peers bootstrap autorizados y otros parámetros de red.
- **Nodo bootstrap (`ipfs-bootstrap`)**: primer punto de entrada a la red. Su `PeerID` debe propagarse mediante el autoconf antes de levantar nodos trabajadores.
- **Nodos Kubo (`ipfs-node1`, `ipfs-node2`, …)**: participan en la red privada y opcionalmente exponen la WebUI sobre los puertos mapeados.
- **Clúster IPFS (`ipfs-cluster1`, `ipfs-cluster2`)**: gestiona replicación de contenidos y orquesta los nodos Kubo mediante el protocolo de clusterización de IPFS.
- **Monitorización (`prometheus`, `grafana`)**: recopila métricas y ofrece dashboards para supervisar el estado de la red.

## Redes y volúmenes

- Todos los servicios comparten la red bridge `almena-network`, lo que permite resolver nombres entre contenedores.
- Se definen volúmenes persistentes por componente (`ipfs-bootstrap-data`, `ipfs-node*-data`, `ipfs-cluster*-data`, `prometheus-data`, `grafana-data`) para conservar repositorios IPFS, configuraciones y datos de métricas tras reinicios.

## Flujo de despliegue recomendado

1. Levantar el perfil `bootstrap` y registrar el `PeerID` del nodo raíz.
2. Actualizar `autoconf.json` con el nuevo `PeerID`.
3. Arrancar los perfiles de nodos Kubo que participarán en la red.
4. Activar los perfiles de clúster IPFS si se requiere coordinación entre nodos.
5. Iniciar la monitorización para obtener métricas y dashboards.

## Scripts de inicialización

Cada perfil IPFS monta scripts específicos en `/container-init.d/`:

- `ipfs/scripts/bootstrap/020-config.sh`: habilita AutoConf y ajusta políticas del nodo bootstrap.
- `ipfs/scripts/worker/010-webui.sh`: descarga la WebUI en formato CAR y la importa en el repositorio del nodo.
- `ipfs/scripts/worker/020-config.sh`: deshabilita AutoConf en nodos trabajadores y establece cabeceras CORS para la WebUI.

Esta separación facilita mantener configuraciones distintas para el nodo raíz y los nodos participantes, alineadas con el flujo de arranque faseado.
