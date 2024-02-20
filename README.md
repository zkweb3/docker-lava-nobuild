## docker-lava-nobuild

### Building
```bash
docker build . -t lava:latest --no-cache
```
### Running
```bash
docker compose up -d
```
### Useful Commands
```bash
docker exec -it lavad /bin/bash
```
```bash
docker logs -f lavad
```

[more](https://services.kjnodes.com/testnet/lava/useful-commands/)