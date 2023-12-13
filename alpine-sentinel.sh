#!/bin/bash
# Usage: ./setup_redis_sentinel_alpine.sh sentinel [master_ip] [master_port] [master_password] [sentinel_config_file_path]

ROLE=$1

# Function to check if an iptables rule exists
rule_exists() {
    iptables -C "$@" 2>/dev/null
}

# Function to set iptables rules for Redis Sentinel
setup_iptables() {
    local sentinel_port=$1

    # Check and add rule for SSH (port 22)
    if ! rule_exists INPUT -p tcp --dport 22 -j ACCEPT; then
        iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    fi

    # Check and add rule for Redis Sentinel
    if ! rule_exists INPUT -p tcp --dport "$sentinel_port" -j ACCEPT; then
        iptables -A INPUT -p tcp --dport "$sentinel_port" -j ACCEPT
    fi

    # Save the iptables rules
    iptables-save > /etc/iptables/rules.v4
}

setup_sentinel() {
  local master_ip=$1
  local master_port=$2
  local master_password=$3
  local sentinel_config_file=$4

  # Configure Sentinel
  echo "sentinel monitor mymaster $master_ip $master_port 2" > "$sentinel_config_file"
  echo "sentinel down-after-milliseconds mymaster 5000" >> "$sentinel_config_file"
  echo "sentinel failover-timeout mymaster 60000" >> "$sentinel_config_file"
  echo "sentinel auth-pass mymaster $master_password" >> "$sentinel_config_file"

  # Create OpenRC service script for Redis Sentinel
  echo "#!/sbin/openrc-run" > /etc/init.d/redis-sentinel
  echo "command=/usr/bin/redis-sentinel" >> /etc/init.d/redis-sentinel
  echo "command_args=\"$sentinel_config_file\"" >> /etc/init.d/redis-sentinel
  chmod +x /etc/init.d/redis-sentinel

  # Start and enable the Redis Sentinel service
  rc-update add redis-sentinel default
  rc-service redis-sentinel start

  # Setup iptables
  setup_iptables "$master_port"

  echo "Redis Sentinel setup complete."
}

case $ROLE in
  sentinel)
    MASTER_IP=$2
    MASTER_PORT=$3
    MASTER_PASSWORD=$4
    CONFIG_FILE=$5
    setup_sentinel $MASTER_IP $MASTER_PORT $MASTER_PASSWORD $CONFIG_FILE
    ;;
  *)
    echo "Invalid role specified. Use 'sentinel'."
    exit 1
    ;;
esac
