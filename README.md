![logo](https://socialify.git.ci/zkweb3/docker-lava-nobuild/image?description=1&language=1&name=1&owner=1&pattern=Floating%20Cogs&theme=Light)

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

* [more](https://services.kjnodes.com/testnet/lava/useful-commands/)
