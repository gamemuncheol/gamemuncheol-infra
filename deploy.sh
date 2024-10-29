# !/bin/bash

# 서버 
SERVER_URLS=("http://localhost:8081/actuator" "http://localhost:8082/actuator")
SERVER_NAMES=("server-1" "server-2")

MAX_RETRIES=30
WAIT_TIME=10

# 서버 상태 확인
check_server_status() {
  local server_url=$1
  local retries=0

  echo "Checking server status at $server_url..."

  while [[ $retries -lt $MAX_RETRIES ]]; do
    if curl -s --head "$server_url" | grep "200" > /dev/null; then
      echo "Server at $server_url is up and running."
      return 0
    else
      echo "Server at $server_url is not ready yet. Waiting..."
      retries=$((retries + 1))
      sleep $WAIT_TIME
    fi
  done

  echo "Server at $server_url failed to start within the maximum retry limit."
  return 1
}

# 서버를 순차적으로 시작하고 상태 확인
i=0
while [[ $i -lt ${#SERVER_NAMES[@]} ]]; do
  server_name=${SERVER_NAMES[$i]}
  server_url=${SERVER_URLS[$i]}

  echo "stop docker command : docker-compose stop $server_name"
  sudo docker compose stop $server_name
  echo "run docker command : docker-compose up -d $server_name"
  sudo docker compose up -d $server_name

  if check_server_status $server_url; then
    echo "$server_name is successfully started."
  else
    echo "Failed to start $server_name."
    exit 1
  fi

  i=$((i + 1))
done

echo "Rolling deployment completed successfully."
