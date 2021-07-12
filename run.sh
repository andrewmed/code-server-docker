set -ex
docker stop code-server-docker || true
docker rm code-server-docker || true
docker run -d --name code-server-docker -p 0.0.0.0:8080:8080 \
  -u "$(id -u):$(id -g)" \
  -v "$HOME:$HOME/code" \
  --restart unless-stopped \
  code-server-docker:latest