```
./redis-ha.sh                

Usage:

     On Master:
       ./redis-ha.sh master [master_ip] [master_port] [config_file_path] [master_password]
       ./redis-ha.sh master 192.168.1.100 6379 /etc/redis/redis.conf myRedisPass123
       ./redis-ha.sh master 192.168.1.100 6479 /etc/redis6479/redis6479.conf myRedisPass123

     On Slave:
       ./redis-ha.sh slave [master_ip] [master_port] [config_file_path] [master_password]
       ./redis-ha.sh slave 192.168.1.101 6379 /etc/redis/redis.conf myRedisPass123
       ./redis-ha.sh slave 192.168.1.101 6480 /etc/redis6479/redis6480.conf myRedisPass123

     For Sentinel:
       ./redis-ha.sh sentinel [master_ip] [master_port] [master_password] [sentinel_config_file_path]
       ./redis-ha.sh sentinel 192.168.1.100 6379 myRedisPass123 /etc/redis/sentinel.conf
       ./redis-ha.sh sentinel 192.168.1.100 6479 myRedisPass123 /etc/redis6479/sentinel-redis6479.conf
```