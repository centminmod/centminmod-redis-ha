#!/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"
# set locale temporarily to english
# due to some non-english locale issues
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
# disable systemd pager so it doesn't pipe systemctl output to less
export SYSTEMD_PAGER=''
# ==========================================================================
# Usage:
# Master: ./setup_redis.sh master [master_ip] [master_port] [config_file_path] [master_password]
# Slave: ./setup_redis.sh slave [master_ip] [master_port] [slave_port] [config_file_path] [master_password]
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
# ./setup_redis.sh slave [master_ip] [master_port] [slave_port] [config_file_path] [master_password]
#
# Example:
#
# ./setup_redis.sh slave 192.168.1.101 6379 6380 /etc/redis/redis.conf myRedisPass123
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
configure_redis_master() {
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

  if [ "$port" -ne '6379' ]; then
    echo "systemctl start redis${port}"
    systemctl start redis${port}
    echo
    echo "systemctl status redis${port}"
    systemctl status redis${port}
  else
    echo "systemctl start redis"
    systemctl start redis
    echo
    echo "systemctl status redis"
    systemctl status redis
  fi
  echo "Redis $ROLE $ip $port $config_file setup complete."
}

# Configure Redis based on the role
configure_redis_slave() {
  local ip=$1
  local port=$2
  local port_slave=$3
  local config_file=$4
  local password=$5

  sed -i "s/^bind 127.0.0.1/bind $ip/" $config_file
  sed -i "s/^port 6379/port $port_slave/" $config_file
  echo "requirepass $password" >> $config_file

  if [ "$ROLE" == "slave" ]; then
    echo "slaveof $ip $port" >> $config_file
    echo "masterauth $password" >> $config_file
  fi

  if [ "$port_slave" -ne '6379' ]; then
    echo "systemctl start redis${port_slave}"
    systemctl start redis${port_slave}
    echo
    echo "systemctl status redis${port_slave}"
    systemctl status redis${port_slave}
  else
    echo "systemctl start redis"
    systemctl start redis
    echo
    echo "systemctl status redis"
    systemctl status redis
  fi
  echo "Redis $ROLE $ip $port_slave $config_file with master $port setup complete."
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
    \cp -af /usr/lib/systemd/system/redis-sentinel.service "$custom_service_file"
    sed -i "s|/etc/redis/sentinel.conf|$sentinel_config_file|" "$custom_service_file"

    # Modify original or custom sentinel config file
    sed -i "s/^sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster $master_ip $master_port 2/" "$sentinel_config_file"
    sed -i "s/^# sentinel auth-pass <master-name> <password>/sentinel auth-pass mymaster $master_password/" "$sentinel_config_file"

    # fix noexec /tmp
    mkdir -p /home/redistmp
    chown redis:redis /home/redistmp
    chmod 1777 /home/redistmp
    sed -i 's|dir /tmp|dir /home/redistmp|' "$sentinel_config_file"
    # fix PID path
    sed -i 's|pidfile /var/run/redis-|pidfile /var/run/redis/redis-|' "$sentinel_config_file"

    # setup limit.conf
    mkdir -p "/etc/systemd/system/redis-sentinel-${master_port}.service.d"
    if [ -f /etc/systemd/system/redis-sentinel.service.d/limit.conf ]; then
      \cp -af /etc/systemd/system/redis-sentinel.service.d/limit.conf "/etc/systemd/system/redis-sentinel-${master_port}.service.d/limit.conf"
      sed -i "s|LimitNOFILE=.*|LimitNOFILE=524288|" "/etc/systemd/system/redis-sentinel-${master_port}.service.d/limit.conf"
    fi
  else
    # Modify original or custom sentinel config file
    sed -i "s/^sentinel monitor mymaster 127.0.0.1 6379 2/sentinel monitor mymaster $master_ip $master_port 2/" "$sentinel_config_file"
    sed -i "s/^# sentinel auth-pass mymaster <password>/sentinel auth-pass mymaster $master_password/" "$sentinel_config_file"
    if [ -f /etc/systemd/system/redis-sentinel.service.d/limit.conf ]; then
      sed -i "s|LimitNOFILE=.*|LimitNOFILE=524288|" /etc/systemd/system/redis-sentinel.service.d/limit.conf
    fi
    # fix noexec /tmp
    mkdir -p /home/redistmp
    chown redis:redis /home/redistmp
    chmod 1777 /home/redistmp
    sed -i 's|dir /tmp|dir /home/redistmp|' "$sentinel_config_file"
    # fix PID path
    sed -i 's|pidfile /var/run/redis-|pidfile /var/run/redis/redis-|' "$sentinel_config_file"
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
  echo
  echo "systemctl start $service_name"
  systemctl start "$service_name"
  echo
  echo "systemctl status $service_name"
  systemctl status "$service_name"

  echo "Redis Sentinel $master_ip $master_port $sentinel_config_file service setup complete."
}

help() {
  echo
  echo "Usage:"
  echo
  echo "     On Master:"
  echo "       $0 master [master_ip] [master_port] [config_file_path] [master_password]"
  echo "       $0 master 192.168.1.100 6379 /etc/redis/redis.conf myRedisPass123"
  echo "       $0 master 192.168.1.100 6479 /etc/redis6479/redis6479.conf myRedisPass123"
  echo
  echo "     On Slave:"
  echo "       $0 slave [master_ip] [master_port] [slave_port] [config_file_path] [master_password]"
  echo "       $0 slave 192.168.1.101 6379 /etc/redis/redis.conf myRedisPass123"
  echo "       $0 slave 192.168.1.101 6379 6480 /etc/redis6480/redis6480.conf myRedisPass123"
  echo
  echo "     For Sentinel:"
  echo "       $0 sentinel [master_ip] [master_port] [master_password] [sentinel_config_file_path]"
  echo "       $0 sentinel 192.168.1.100 6379 myRedisPass123 /etc/redis/sentinel.conf"
  echo "       $0 sentinel 192.168.1.100 6479 myRedisPass123 /etc/redis6479/sentinel-redis6479.conf"
}

case $ROLE in
  master)
    IP=$2
    PORT=$3
    CONFIG_FILE=$4
    MASTER_PASSWORD=$5
    configure_redis_master $IP $PORT $CONFIG_FILE $MASTER_PASSWORD
    ;;
  slave)
    IP=$2
    PORT=$3
    SLAVE_PORT=$4
    CONFIG_FILE=$5
    MASTER_PASSWORD=$6
    configure_redis_slave $IP $PORT $SLAVE_PORT $CONFIG_FILE $MASTER_PASSWORD
    ;;
  sentinel)
    MASTER_IP=$2
    MASTER_PORT=$3
    MASTER_PASSWORD=$4
    CONFIG_FILE=$5
    setup_sentinel $MASTER_IP $MASTER_PORT $MASTER_PASSWORD $CONFIG_FILE
    ;;
  *)
    help
    exit 1
    ;;
esac
