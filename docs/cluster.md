# Clúster IPFS

El clúster permite orquestar replicación y pinning coordinado sobre los nodos Kubo. En `compose.yml` se definen dos instancias (`ipfs-cluster1` e `ipfs-cluster2`) encapsuladas en los perfiles `cluster1`, `cluster2` y `cluster`.

## Configuración esencial

- `CLUSTER_PEERNAME`: nombre lógico del peer dentro del clúster.
- `CLUSTER_SECRET`: token compartido por todos los peers. **Debes establecerlo antes de arrancar** para evitar que los peers arranquen en modo inseguro.
- `CLUSTER_IPFSHTTP_NODEMULTIADDRESS`: multiaddress que apunta al nodo Kubo que gestionará cada peer.
- `CLUSTER_METRICS_PROMETHEUSENDPOINT`: expone métricas que Prometheus puede recolectar.

## Despliegue

1. Asegúrate de que los nodos Kubo correspondientes (`ipfs-node1`, `ipfs-node2`) ya están en ejecución y conectados al bootstrap.
2. Define el secreto (64 bytes hexadecimales o base64 recomendado):
   ```bash
   export CLUSTER_SECRET=$(openssl rand -hex 32)
   ```
3. Levanta el perfil deseado:
   ```bash
   CLUSTER_SECRET=$CLUSTER_SECRET docker compose --profile cluster up -d
   # o perfiles individuales:
   CLUSTER_SECRET=$CLUSTER_SECRET docker compose --profile cluster1 up -d
   ```

## Operaciones comunes

- **Estado del clúster**  
  ```bash
  docker compose --profile cluster exec ipfs-cluster1 ipfs-cluster-ctl peers ls
  ```

- **Fijar contenidos**  
  ```bash
  docker compose --profile cluster exec ipfs-cluster1 ipfs-cluster-ctl pin add <CID>
  ```

- **Eliminar peers**  
  Escala a cero el servicio:
  ```bash
  docker compose --profile cluster rm -sf ipfs-cluster2
  ```

## Buenas prácticas

- Mantén el `CLUSTER_SECRET` fuera del control de versiones.
- Ajusta el número de réplicas deseadas (`pinning replication factor`) según la cantidad de nodos disponibles.
- Exponer el puerto 9095 permite administrar el clúster mediante la API HTTP; asegúrate de resguardarlo detrás de una capa segura si necesitas abrirlo a otras redes.
