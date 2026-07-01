# Service Profiles

Service profiles are reusable compose snippets for task-local dependencies.

List profiles:

```sh
devel profile list
```

Copy a profile into a task:

```sh
devel profile copy sqlserver-minio-centrifugo my-task
cd "$(devel path my-task)"
docker compose -f compose.sqlserver-minio-centrifugo.yaml up -d
```

Available profiles:

- `node-web`: a basic Node/Bun web app runner with exposed internal ports 3000, 4000, and 4200.
- `sqlserver-minio-centrifugo`: SQL Server, MinIO, and Centrifugo dependencies for platform-style tasks.
