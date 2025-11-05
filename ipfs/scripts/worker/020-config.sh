#!/bin/sh
set -ex
ipfs config --json AutoConf.Enabled false
ipfs config --json AutoTLS.Enabled false
ipfs config --json API.HTTPHeaders \
    '{
        "Access-Control-Allow-Origin": ["http://localhost:'${IPFS_WEBUI_PORT}'", "http://127.0.0.1:'${IPFS_WEBUI_PORT}'", "http://'${HOSTNAME}':'${IPFS_WEBUI_PORT}'"],
        "Access-Control-Allow-Methods": ["PUT", "POST"]
    }'
ipfs config --json Routing.Type '"none"'
ipfs config --json Swarm.DisableNatPortMap true
ipfs config --json Swarm.Transports.Network.Websocket false
ipfs config --json Gateway.NoFetch true
ipfs config --json DNS.Resolvers '{}'
ipfs config --json Routing.DelegatedRouters '[]'
ipfs config --json Ipns.DelegatedPublishers '[]'
ipfs bootstrap rm --all