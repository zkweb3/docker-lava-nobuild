#!/bin/bash
STATE_DB="/root/.lava/data/state.db"
if ! [ -e ${STATE_DB} ]; then
  lavad init ${LAVA_MONIKER} --chain-id ${LAVA_CHAIN_ID}
  lavad config keyring-backend test
  cp /root/.lava/data/priv_validator_state.json /root/.lava/priv_validator_state.json.backup
  lavad tendermint unsafe-reset-all --keep-addr-book --home /root/.lava
  curl -L https://snapshots.kjnodes.com/lava-testnet/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C /root/.lava
  mv /root/.lava/priv_validator_state.json.backup /root/.lava/data/priv_validator_state.json
fi
STATE_SYNC_RPC=https://lava-testnet.rpc.kjnodes.com:443
SEED_NODE1=3a445bfdbe2d0c8ee82461633aa3af31bc2b4dc0@testnet2-seed-node.lavanet.xyz:26656
SEED_NODE2=e593c7a9ca61f5616119d6beb5bd8ef5dd28d62d@testnet2-seed-node2.lavanet.xyz:26656
STATE_SYNC_PEER=d5519e378247dfb61dfe90652d1fe3e2b3005a5b@lava-testnet.rpc.kjnodes.com:14456
LATEST_HEIGHT=$(curl -s $STATE_SYNC_RPC/block | jq -r .result.block.header.height)
SYNC_BLOCK_HEIGHT=$(($LATEST_HEIGHT - 1000))
SYNC_BLOCK_HASH=$(curl -s "$STATE_SYNC_RPC/block?height=$SYNC_BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i \
  -e "s|^enable *=.*|enable = true|" \
  -e "s|^rpc_servers *=.*|rpc_servers = \"$STATE_SYNC_RPC,$STATE_SYNC_RPC\"|" \
  -e "s|^trust_height *=.*|trust_height = $SYNC_BLOCK_HEIGHT|" \
  -e "s|^trust_hash *=.*|trust_hash = \"$SYNC_BLOCK_HASH\"|" \
  -e "s|^persistent_peers *=.*|persistent_peers = \"$STATE_SYNC_PEER\"|" \
  -e "s|^seeds *=.*|seeds =\"$SEED_NODE1,$SEED_NODE2\"|" \
  /root/.lava/config/config.toml

lavad start