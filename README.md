# relay_swarm
Multi-region local-read, global write nostr relay deployed with docker swarm, backed by Posgresql

## Create overlay network

```bash
docker network create --driver overlay --attachable swarm-overlay-network
```


## Commands to Deploy stack

```bash
docker stack deploy -c docker-compose-pg-primary.yaml primary-db
docker stack deploy -c docker-compose-pg-secondary.yaml secondary-db
docker stack deploy -c docker-compose-nostpy-services.yaml relay-nostpy-services
docker stack deploy -c docker-compose-nostpy-secondary.yaml relay-nostpy-secondary
docker stack deploy -c docker-compose-otel.yaml opentelemetry-stack
docker stack deploy -c docker-compose-ng-nostpy.yaml ng-nostpy
```

### Update node labels

```bash
docker node update --label-add region=primary <node-id>
docker node update --label-add region=useast <node-id>
docker node update --label-add region=asia <node-id>
docker node update --label-add role=dbprimary <node-id>
docker node update --label-add role=replica <node-id>
```

### Create configs

```bash
docker config create opentelemetry-config ./config-opentelemetry.yaml
docker config create config_secondary_region.conf ./config_secondary_region.conf
docker config create config_primary_region.conf ./config_primary_region.conf
docker config create config_pg_hba.conf ./pg_hba.conf

```

### Initiatate replica for streaming
TO be run on replica databases
```bash
PGPASSWORD=password pg_basebackup -h <PRIMARY_DB_IP> -D /tmp/postgresslave -U replica_<REGION> -S replica_slot -X stream -P -Fp -R
```
