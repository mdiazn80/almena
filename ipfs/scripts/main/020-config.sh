#!/bin/sh
set -ex
ipfs config --json AutoConf.Enabled true
ipfs config --json AutoConf.URL '"http://autoconf-server/autoconf.json"'
ipfs config --json AutoTLS.Enabled false
ipfs config --json Routing.Type '"dht"'
ipfs config --json Swarm.DisableNatPortMap true
ipfs config --json Swarm.Transports.Network.Websocket false
ipfs config --json Gateway.NoFetch true
