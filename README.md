# dockerxmrig

Docker image for running [XMRig](https://github.com/xmrig/xmrig) from a pinned upstream release.

## Included versions

- XMRig `v6.26.0`
- Alpine `3.22`

The image uses a multi-stage build so the final runtime image only contains the XMRig binary and its runtime libraries.

## Build

```bash
docker build -t dockerxmrig .
```

## Configure XMRig at runtime

Do not bake personal wallet, pool, or worker credentials into the image.

1. Copy the example config and update it for your pool and wallet:

   ```bash
   cp config.json config.local.json
   ```

2. Edit `config.local.json` with your pool endpoint, wallet or username, password, and any additional XMRig options you need.

The checked-in `config.json` is only a safe example template. Replace `pool.example.com:3333` with your actual pool host and port, and set `tls` to match that endpoint. The image also includes this safe template at `/config/config.json` and defaults to that path when you start the container. If you pass your own arguments, include `--config=/config/config.json` explicitly.

## Run with a mounted config

```bash
docker run --rm \
  -v "$PWD/config.local.json:/config/config.json:ro" \
  dockerxmrig --config=/config/config.json
```

## Run with direct arguments

```bash
docker run --rm dockerxmrig --help
docker run --rm dockerxmrig --url pool.example.com:3333 --user YOUR_WALLET_OR_USERNAME --pass x
```

## Maintenance

- GitHub Actions builds the Docker image on pushes and pull requests.
- A scheduled workflow checks the pinned `XMRIG_VERSION` in the Dockerfile against the latest upstream XMRig release and opens an issue when a newer release is available.
