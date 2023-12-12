#!/bin/bash
# ==========================================================================
# Usage:
# Master: ./setup_redis.sh master [master_ip] [master_port] [config_file_path] [master_password]
# Slave: ./setup_redis.sh slave [master_ip] [master_port] [config_file_path] [master_password]
# Sentinel: ./setup_redis.sh sentinel [master_ip] [master_port] [master_password] [sentinel_config_file_path]
# ==========================================================================
# USAGE EXAMPLES FOR setup_redis.sh SCRIPT
# ==========================================================================
# For Setting Up a Master Redis Server:
# -------------------------------------
# ./setup_redis.sh master [master_ip] [master_port] [config_file_path] [master_password]
#
# Example:
#
# ./setup_redis.sh master 192.168.1.100 6379 /etc/redis/redis.conf myRedisPass123
#
# Here, '192.168.1.100' is the IP address where the master Redis server is running,
# '6379' is the port number for the Redis master,
# '/etc/redis/redis.conf' is the path to the Redis configuration file,
# and 'myRedisPass123' is the password for accessing the Redis master.

# For Setting Up a Slave Redis Server:
# ------------------------------------
# ./setup_redis.sh slave [master_ip] [master_port] [config_file_path] [master_password]
#
# Example:
#
# ./setup_redis.sh slave 192.168.1.101 6379 /etc/redis/redis.conf myRedisPass123
#
# Here, '192.168.1.101' is the IP address of the slave server (where the slave Redis server will bind),
# '6379' is the port number for the Redis slave (can be different from the master's port if on the same machine),
# '/etc/redis/redis.conf' is the path to the Redis configuration file on the slave server,
# and 'myRedisPass123' is the password, which must be the same as the master's for authentication.

# For Setting Up a Redis Sentinel Server:
# ---------------------------------------
# ./setup_redis.sh sentinel [master_ip] [master_port] [master_password] [sentinel_config_file_path]
#
# Example:
#
# ./setup_redis.sh sentinel 192.168.1.100 6379 myRedisPass123 /etc/redis/sentinel.conf
#
# Here, '192.168.1.100' is the IP address of the master Redis server that the Sentinel will monitor,
# '6379' is the port number of the master Redis server,
# 'myRedisPass123' is the password for the master Redis server (needed for Sentinel to authenticate),
# and '/etc/redis/sentinel.conf' is the path to the Sentinel configuration file.

# NOTE:
# - Replace IP addresses, ports, file paths, and passwords with the actual values from your environment.
# - Ensure that the Redis master, slave, and sentinel can communicate over the network (check firewall settings, etc.).
# - Always test configurations in a non-production environment first.
# - Run the script with appropriate privileges for system-wide changes (root or sudo).
# ==========================================================================

ROLE=$1

# Configure Redis based on the role
configure_redis() {
  local ip=$1
  local port=$2
  local config_file=$3
  local password=$4

  sed -i "s/^bind 127.0.0.1/bind $ip/" $config_file
  sed -i "s/^port 6379/port $port/" $config_file
  echo "requirepass $password" >> $config_file

  if [ "$ROLE" == "slave" ]; then
    echo "slaveof $ip $port" >> $config_file
    echo "masterauth $password" >> $config_file
  fi

  systemctl start redis
  echo "Redis $ROLE setup complete."
}

# Setup Sentinel
setup_sentinel() {
  local master_ip=$1
  local master_port=$2
  local master_password=$3
  local sentinel_config_file=$4

  # Check if custom config file path is provided and different from default
  if [ "$sentinel_config_file" != "/etc/redis/sentinel.conf" ]; then
    # Copy default config file to custom path
    \cp -af /etc/redis/sentinel.conf "$sentinel_config_file"

    # Update log and pid file paths in custom config
    sed -i "s|logfile /var/log/redis/sentinel.log|logfile /var/log/redis/sentinel-${master_port}.log|" "$sentinel_config_file"
    sed -i "s|pidfile /var/run/redis-sentinel.pid|pidfile /var/run/redis-sentinel-${master_port}.pid|" "$sentinel_config_file"

    # Copy and modify systemd service file
    local custom_service_file="/usr/lib/systemd/system/redis-sentinel-${master_port}.service"
    cp -a /usr/lib/systemd/system/redis-sentinel.service "$custom_service_file"
    sed -i "s|/etc/redis/sentinel.conf|$sentinel_config_file|" "$custom_service_file"

  else
    # Modify original or custom sentinel config file
    sed -i "s/^sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster $master_ip $master_port 2/" "$sentinel_config_file"
    sed -i "s/^# sentinel auth-pass mymaster <password>/sentinel auth-pass mymaster $master_password/" "$sentinel_config_file"
  fi

  # Reload systemd to recognize new service
  systemctl daemon-reload

  # Start and enable the appropriate Sentinel service
  local service_name="redis-sentinel"
  if [ "$sentinel_config_file" != "/etc/redis/sentinel.conf" ]; then
    service_name="redis-sentinel-${master_port}"
  fi
  echo "systemctl enable $service_name"
  systemctl enable "$service_name"
  echo "systemctl start $service_name"
  systemctl start "$service_name"

  echo "Redis Sentinel service setup complete."
}

case $ROLE in
  master|slave)
    IP=$2
    PORT=$3
    CONFIG_FILE=$4
    MASTER_PASSWORD=$5
    configure_redis $IP $PORT $CONFIG_FILE $MASTER_PASSWORD
    ;;
  sentinel)
    MASTER_IP=$2
    MASTER_PORT=$3
    MASTER_PASSWORD=$4
    CONFIG_FILE=$5
    setup_sentinel $MASTER_IP $MASTER_PORT $MASTER_PASSWORD $CONFIG_FILE
    ;;
  *)
    echo "Invalid role specified. Use 'master', 'slave', or 'sentinel'."
    exit 1
    ;;
esac
