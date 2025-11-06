#!/bin/sh
set -e

# Ruta al datadir (por defecto /data en tu docker-compose)
DATADIR=${GETH_DATADIR:-/data}

# Si la cadena aún no está inicializada, ejecuta "geth init"
if [ ! -d "$DATADIR/geth/chaindata" ]; then
  echo "🔧 Primera inicialización: ejecutando geth init..."
  geth --datadir "$DATADIR" init "$DATADIR/genesis.json"
else
  echo "✅ Cadena ya inicializada, saltando 'geth init'."
fi

# Luego, ejecuta el comando principal del contenedor (los flags del nodo)
exec geth "$@"
