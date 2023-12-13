```
./redis-ha.sh                

Usage:

     On Master:
       ./redis-ha.sh master [master_ip] [master_port] [config_file_path] [master_password]
       ./redis-ha.sh master 192.168.1.100 6379 /etc/redis/redis.conf myRedisPass123
       ./redis-ha.sh master 192.168.1.100 6479 /etc/redis6479/redis6479.conf myRedisPass123

     On Slave:
       ./redis-ha.sh slave [master_ip] [master_port] [slave_port] [config_file_path] [master_password]
       ./redis-ha.sh slave 192.168.1.101 6379 6380 /etc/redis/redis.conf myRedisPass123
       ./redis-ha.sh slave 192.168.1.101 6479 6480 /etc/redis6480/redis6480.conf myRedisPass123

     For Sentinel:
       ./redis-ha.sh sentinel [master_ip] [master_port] [master_password] [sentinel_config_file_path]
       ./redis-ha.sh sentinel 192.168.1.100 6379 myRedisPass123 /etc/redis/sentinel.conf
       ./redis-ha.sh sentinel 192.168.1.100 6479 myRedisPass123 /etc/redis6479/sentinel-redis6479.conf
```

Example same server Redis master/slave replication with single Redis Sentinel setup for 2x Redis server instances on port `6479` and `6480` created via https://github.com/centminmod/centminmod-redis

```
./redis-ha.sh master 127.0.0.1 6479 /etc/redis6479/redis6479.conf myRedisPass123

./redis-ha.sh slave 127.0.0.1 6479 6480 /etc/redis6480/redis6480.conf myRedisPass123

./redis-ha.sh sentinel 127.0.0.1 6479 myRedisPass123 /etc/redis6479/sentinel-redis6479.conf
```

# Redis Master

```
./redis-ha.sh master 127.0.0.1 6479 /etc/redis6479/redis6479.conf myRedisPass123
systemctl start redis6479

systemctl status redis6479
● redis6479.service - Redis persistent key-value database
   Loaded: loaded (/usr/lib/systemd/system/redis6479.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/redis6479.service.d
           └─limit.conf, user.conf
   Active: active (running) since Tue 2023-12-12 06:31:42 UTC; 16h ago
 Main PID: 4110001 (redis-server)
   Status: "Ready to accept connections"
    Tasks: 5 (limit: 23903)
   Memory: 2.6M
   CGroup: /system.slice/redis6479.service
           └─4110001 /etc/redis6479/redis-server 127.0.0.1:6479

Dec 12 06:31:42 hostname systemd[1]: Starting Redis persistent key…...
Dec 12 06:31:42 hostname systemd[1]: Started Redis persistent key-…se.
Hint: Some lines were ellipsized, use -l to show in full.
Redis master 127.0.0.1 6479 /etc/redis6479/redis6479.conf setup complete.
```

```
export REDIS_PASSWORD='myRedisPass123'
redis-cli -a $REDIS_PASSWORD -h 127.0.0.1 -p 6479 info
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
# Server
redis_version:7.2.3
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:533c8a7f18e07f43
redis_mode:standalone
os:Linux 4.18.0-477.27.2.el8_8.x86_64 x86_64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:epoll
atomicvar_api:c11-builtin
gcc_version:8.5.0
process_id:4147401
process_supervised:systemd
run_id:f9f0b03e00451f392f303ec7f3eb23f7f50ef6b8
tcp_port:6479
server_time_usec:1702424843493795
uptime_in_seconds:479
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:7926027
executable:/etc/redis6479/redis-server
config_file:/etc/redis6479/redis6479.conf
io_threads_active:0
listener0:name=tcp,bind=127.0.0.1,bind=-::1,port=6479

# Clients
connected_clients:3
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:20480
client_recent_max_output_buffer:20504
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
total_blocking_keys:0
total_blocking_keys_on_nokey:0

# Memory
used_memory:1194320
used_memory_human:1.14M
used_memory_rss:11329536
used_memory_rss_human:10.80M
used_memory_peak:1194320
used_memory_peak_human:1.14M
used_memory_peak_perc:100.15%
used_memory_overhead:931748
used_memory_startup:866168
used_memory_dataset:262572
used_memory_dataset_perc:80.02%
allocator_allocated:1442152
allocator_active:1761280
allocator_resident:6934528
total_system_memory:3998314496
total_system_memory_human:3.72G
used_memory_lua:31744
used_memory_vm_eval:31744
used_memory_lua_human:31.00K
used_memory_scripts_eval:0
number_of_cached_scripts:0
number_of_functions:0
number_of_libraries:0
used_memory_vm_functions:32768
used_memory_vm_total:64512
used_memory_vm_total_human:63.00K
used_memory_functions:184
used_memory_scripts:184
used_memory_scripts_human:184B
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.22
allocator_frag_bytes:319128
allocator_rss_ratio:3.94
allocator_rss_bytes:5173248
rss_overhead_ratio:1.63
rss_overhead_bytes:4395008
mem_fragmentation_ratio:9.82
mem_fragmentation_bytes:10175232
mem_not_counted_for_evict:0
mem_replication_backlog:41012
mem_total_replication_buffers:41008
mem_clients_slaves:0
mem_clients_normal:24384
mem_cluster_links:0
mem_aof_buffer:0
mem_allocator:jemalloc-5.3.0
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0

# Persistence
loading:0
async_loading:0
current_cow_peak:0
current_cow_size:0
current_cow_size_age:0
current_fork_perc:0.00
current_save_keys_processed:0
current_save_keys_total:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1702424364
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
rdb_saves:0
rdb_last_cow_size:0
rdb_last_load_keys_expired:0
rdb_last_load_keys_loaded:0
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_rewrites:0
aof_rewrites_consecutive_failures:0
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0

# Stats
total_connections_received:8
total_commands_processed:1229
instantaneous_ops_per_sec:2
total_net_input_bytes:57170
total_net_output_bytes:324578
total_net_repl_input_bytes:0
total_net_repl_output_bytes:31936
instantaneous_input_kbps:0.14
instantaneous_output_kbps:0.17
instantaneous_input_repl_kbps:0.00
instantaneous_output_repl_kbps:0.08
rejected_connections:0
sync_full:0
sync_partial_ok:1
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:5
evicted_keys:0
evicted_clients:0
total_eviction_exceeded_time:0
current_eviction_exceeded_time:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:1
pubsub_patterns:0
pubsubshard_channels:0
latest_fork_usec:0
total_forks:0
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
total_active_defrag_time:0
current_active_defrag_time:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_error_replies:5
dump_payload_sanitizations:0
total_reads_processed:1209
total_writes_processed:1243
io_threaded_reads_processed:0
io_threaded_writes_processed:0
reply_buffer_shrinks:50
reply_buffer_expands:47
eventloop_cycles:5986
eventloop_duration_sum:558492
eventloop_duration_cmd_sum:6093
instantaneous_eventloop_cycles_per_sec:11
instantaneous_eventloop_duration_usec:108
acl_access_denied_auth:0
acl_access_denied_cmd:0
acl_access_denied_key:0
acl_access_denied_channel:0

# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6480,state=online,offset=104452,lag=1
master_failover_state:no-failover
master_replid:704d8088fa70fd521224803398b1234479327f1f
master_replid2:585c0fa684a567dfa287ddca377357c3cbc0d695
master_repl_offset:104585
second_repl_offset:72650
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:72650
repl_backlog_histlen:31936

# CPU
used_cpu_sys:0.299968
used_cpu_user:0.408163
used_cpu_sys_children:0.000000
used_cpu_user_children:0.000000
used_cpu_sys_main_thread:0.298900
used_cpu_user_main_thread:0.408168

# Modules

# Errorstats
errorstat_NOAUTH:count=5

# Cluster
cluster_enabled:0

# Keyspace
```

```
tail -100 /var/log/redis/redis6479.log 
```

# Redis Slave

```
./redis-ha.sh slave 127.0.0.1 6479 6480 /etc/redis6480/redis6480.conf myRedisPass123
systemctl start redis6480

systemctl status redis6480
● redis6480.service - Redis persistent key-value database
   Loaded: loaded (/usr/lib/systemd/system/redis6480.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/redis6480.service.d
           └─limit.conf, user.conf
   Active: active (running) since Tue 2023-12-12 06:31:42 UTC; 16h ago
 Main PID: 4110113 (redis-server)
   Status: "Ready to accept connections"
    Tasks: 5 (limit: 23903)
   Memory: 2.6M
   CGroup: /system.slice/redis6480.service
           └─4110113 /etc/redis6480/redis-server 127.0.0.1:6480

Dec 12 06:31:42 hostname systemd[1]: Starting Redis persistent key…...
Dec 12 06:31:42 hostname systemd[1]: Started Redis persistent key-…se.
Hint: Some lines were ellipsized, use -l to show in full.
Redis slave 127.0.0.1 6480 /etc/redis6480/redis6480.conf setup complete.
```

```
export REDIS_PASSWORD='myRedisPass123'
redis-cli -a $REDIS_PASSWORD -h 127.0.0.1 -p 6480 info
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
# Server
redis_version:7.2.3
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:533c8a7f18e07f43
redis_mode:standalone
os:Linux 4.18.0-477.27.2.el8_8.x86_64 x86_64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:epoll
atomicvar_api:c11-builtin
gcc_version:8.5.0
process_id:4147410
process_supervised:systemd
run_id:75f6dc28164a731c26cd5ce8714dbe0f10c3860a
tcp_port:6480
server_time_usec:1702424907600405
uptime_in_seconds:543
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:7926091
executable:/etc/redis6480/redis-server
config_file:/etc/redis6480/redis6480.conf
io_threads_active:0
listener0:name=tcp,bind=127.0.0.1,bind=-::1,port=6480

# Clients
connected_clients:4
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:20480
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
total_blocking_keys:0
total_blocking_keys_on_nokey:0

# Memory
used_memory:1149888
used_memory_human:1.10M
used_memory_rss:11296768
used_memory_rss_human:10.77M
used_memory_peak:1170152
used_memory_peak_human:1.12M
used_memory_peak_perc:98.27%
used_memory_overhead:934852
used_memory_startup:866168
used_memory_dataset:215036
used_memory_dataset_perc:75.79%
allocator_allocated:1223360
allocator_active:1568768
allocator_resident:4681728
total_system_memory:3998314496
total_system_memory_human:3.72G
used_memory_lua:31744
used_memory_vm_eval:31744
used_memory_lua_human:31.00K
used_memory_scripts_eval:0
number_of_cached_scripts:0
number_of_functions:0
number_of_libraries:0
used_memory_vm_functions:32768
used_memory_vm_total:64512
used_memory_vm_total_human:63.00K
used_memory_functions:184
used_memory_scripts:184
used_memory_scripts_human:184B
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.28
allocator_frag_bytes:345408
allocator_rss_ratio:2.98
allocator_rss_bytes:3112960
rss_overhead_ratio:2.41
rss_overhead_bytes:6615040
mem_fragmentation_ratio:10.18
mem_fragmentation_bytes:10186896
mem_not_counted_for_evict:0
mem_replication_backlog:41012
mem_total_replication_buffers:41008
mem_clients_slaves:0
mem_clients_normal:27488
mem_cluster_links:0
mem_aof_buffer:0
mem_allocator:jemalloc-5.3.0
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0

# Persistence
loading:0
async_loading:0
current_cow_peak:0
current_cow_size:0
current_cow_size_age:0
current_fork_perc:0.00
current_save_keys_processed:0
current_save_keys_total:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1702424364
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
rdb_saves:0
rdb_last_cow_size:0
rdb_last_load_keys_expired:0
rdb_last_load_keys_loaded:0
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_rewrites:0
aof_rewrites_consecutive_failures:0
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0

# Stats
total_connections_received:3
total_commands_processed:1171
instantaneous_ops_per_sec:2
total_net_input_bytes:79907
total_net_output_bytes:404748
total_net_repl_input_bytes:36157
total_net_repl_output_bytes:0
instantaneous_input_kbps:0.19
instantaneous_output_kbps:3.63
instantaneous_input_repl_kbps:0.09
instantaneous_output_repl_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:0
evicted_keys:0
evicted_clients:0
total_eviction_exceeded_time:0
current_eviction_exceeded_time:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:1
pubsub_patterns:0
pubsubshard_channels:0
latest_fork_usec:0
total_forks:0
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
total_active_defrag_time:0
current_active_defrag_time:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_error_replies:0
dump_payload_sanitizations:0
total_reads_processed:1138
total_writes_processed:1877
io_threaded_reads_processed:0
io_threaded_writes_processed:0
reply_buffer_shrinks:56
reply_buffer_expands:54
eventloop_cycles:6544
eventloop_duration_sum:628763
eventloop_duration_cmd_sum:5708
instantaneous_eventloop_cycles_per_sec:12
instantaneous_eventloop_duration_usec:113
acl_access_denied_auth:0
acl_access_denied_cmd:0
acl_access_denied_key:0
acl_access_denied_channel:0

# Replication
role:slave
master_host:127.0.0.1
master_port:6479
master_link_status:up
master_last_io_seconds_ago:1
master_sync_in_progress:0
slave_read_repl_offset:108806
slave_repl_offset:108806
slave_priority:100
slave_read_only:1
replica_announced:1
connected_slaves:0
master_failover_state:no-failover
master_replid:704d8088fa70fd521224803398b1234479327f1f
master_replid2:585c0fa684a567dfa287ddca377357c3cbc0d695
master_repl_offset:108806
second_repl_offset:72650
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:72650
repl_backlog_histlen:36157

# CPU
used_cpu_sys:0.364900
used_cpu_user:0.432059
used_cpu_sys_children:0.000000
used_cpu_user_children:0.000000
used_cpu_sys_main_thread:0.361379
used_cpu_user_main_thread:0.432084

# Modules

# Errorstats

# Cluster
cluster_enabled:0

# Keyspace
```

```
tail -100 /var/log/redis/redis6480.log 
```

# Redis Sentinel

```
./redis-ha.sh sentinel 127.0.0.1 6479 myRedisPass123 /etc/redis6479/sentinel-redis6479.conf
systemctl enable redis-sentinel-6479
Created symlink /etc/systemd/system/multi-user.target.wants/redis-sentinel-6479.service → /usr/lib/systemd/system/redis-sentinel-6479.service.

systemctl start redis-sentinel-6479

systemctl status redis-sentinel-6479
● redis-sentinel-6479.service - Redis Sentinel
   Loaded: loaded (/usr/lib/systemd/system/redis-sentinel-6479.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/redis-sentinel-6479.service.d
           └─limit.conf
   Active: active (running) since Tue 2023-12-12 22:35:44 UTC; 6ms ago
 Main PID: 4144185 (redis-sentinel)
   Status: "Ready to accept connections"
    Tasks: 5 (limit: 23903)
   Memory: 2.6M
   CGroup: /system.slice/redis-sentinel-6479.service
           └─4144185 /usr/bin/redis-sentinel *:26379 [sentinel]

Dec 12 22:35:44 hostname systemd[1]: Starting Redis Sentinel...
Dec 12 22:35:44 hostname systemd[1]: Started Redis Sentinel.
Redis Sentinel 127.0.0.1 6479 /etc/redis6479/sentinel-redis6479.conf service setup complete.
```

```
export REDIS_PASSWORD='myRedisPass123'
redis-cli -h 127.0.0.1 -p 26379 info
# Server
redis_version:7.2.3
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:533c8a7f18e07f43
redis_mode:sentinel
os:Linux 4.18.0-477.27.2.el8_8.x86_64 x86_64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:epoll
atomicvar_api:c11-builtin
gcc_version:8.5.0
process_id:4147394
process_supervised:systemd
run_id:28a6e181224177308b3490176b3ad394321ecd0b
tcp_port:26379
server_time_usec:1702424519602058
uptime_in_seconds:155
uptime_in_days:0
hz:14
configured_hz:10
lru_clock:7925703
executable:/usr/bin/redis-sentinel
config_file:/etc/redis6479/sentinel-redis6479.conf
io_threads_active:0
listener0:name=tcp,bind=*,bind=-::*,port=26379

# Clients
connected_clients:1
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:0
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
total_blocking_keys:0
total_blocking_keys_on_nokey:0

# Stats
total_connections_received:1
total_commands_processed:0
instantaneous_ops_per_sec:0
total_net_input_bytes:14
total_net_output_bytes:0
total_net_repl_input_bytes:0
total_net_repl_output_bytes:0
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
instantaneous_input_repl_kbps:0.00
instantaneous_output_repl_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:3
evicted_keys:0
evicted_clients:0
total_eviction_exceeded_time:0
current_eviction_exceeded_time:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
pubsubshard_channels:0
latest_fork_usec:0
total_forks:0
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
total_active_defrag_time:0
current_active_defrag_time:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_error_replies:0
dump_payload_sanitizations:0
total_reads_processed:1
total_writes_processed:0
io_threaded_reads_processed:0
io_threaded_writes_processed:0
reply_buffer_shrinks:0
reply_buffer_expands:0
eventloop_cycles:2872
eventloop_duration_sum:237154
eventloop_duration_cmd_sum:0
instantaneous_eventloop_cycles_per_sec:23
instantaneous_eventloop_duration_usec:96
acl_access_denied_auth:0
acl_access_denied_cmd:0
acl_access_denied_key:0
acl_access_denied_channel:0

# CPU
used_cpu_sys:0.160711
used_cpu_user:0.142234
used_cpu_sys_children:0.000000
used_cpu_user_children:0.000000
used_cpu_sys_main_thread:0.160273
used_cpu_user_main_thread:0.142101

# Sentinel
sentinel_masters:1
sentinel_tilt:0
sentinel_tilt_since_seconds:-1
sentinel_running_scripts:0
sentinel_scripts_queue_length:0
sentinel_simulate_failure_flags:0
master0:name=mymaster,status=ok,address=127.0.0.1:6479,slaves=1,sentinels=1
```

```
tail -100 /var/log/redis/sentinel-6479.log 
```

# Test Redis master/slave replication

Write to Redis master

```
export REDIS_PASSWORD='myRedisPass123'
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD SET key1 "value1"
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD SET key2 "value2"
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD SET key3 "value3"
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD SET key4 "value4"
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD SET key5 "value5"
```

Read from Redis master

```
export REDIS_PASSWORD='myRedisPass123'
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD GET key1
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD GET key2
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD GET key3
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD GET key4
redis-cli --no-auth-warning -h 127.0.0.1 -p 6479 -a $REDIS_PASSWORD GET key5
```
```
redis-cli --no-auth-warning -a $REDIS_PASSWORD -h 127.0.0.1 -p 6479 -n 0 KEYS '*'
1) "key1"
2) "key2"
3) "key4"
4) "key3"
5) "key5"
```

Read from Redis slave

```
export REDIS_PASSWORD='myRedisPass123'
redis-cli --no-auth-warning -h 127.0.0.1 -p 6480 -a $REDIS_PASSWORD GET key1
redis-cli --no-auth-warning -h 127.0.0.1 -p 6480 -a $REDIS_PASSWORD GET key2
redis-cli --no-auth-warning -h 127.0.0.1 -p 6480 -a $REDIS_PASSWORD GET key3
redis-cli --no-auth-warning -h 127.0.0.1 -p 6480 -a $REDIS_PASSWORD GET key4
redis-cli --no-auth-warning -h 127.0.0.1 -p 6480 -a $REDIS_PASSWORD GET key5
```

```
redis-cli --no-auth-warning -a $REDIS_PASSWORD -h 127.0.0.1 -p 6480 -n 0 KEYS '*'
1) "key3"
2) "key1"
3) "key2"
4) "key5"
5) "key4"
```

Check Redis master

```
redis-cli -a $REDIS_PASSWORD -h 127.0.0.1 -p 6479 info
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
# Server
redis_version:7.2.3
redis_git_sha1:00000000
redis_git_dirty:0
redis_build_id:533c8a7f18e07f43
redis_mode:standalone
os:Linux 4.18.0-477.27.2.el8_8.x86_64 x86_64
arch_bits:64
monotonic_clock:POSIX clock_gettime
multiplexing_api:epoll
atomicvar_api:c11-builtin
gcc_version:8.5.0
process_id:4147401
process_supervised:systemd
run_id:f9f0b03e00451f392f303ec7f3eb23f7f50ef6b8
tcp_port:6479
server_time_usec:1702426579854388
uptime_in_seconds:2215
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:7927763
executable:/etc/redis6479/redis-server
config_file:/etc/redis6479/redis6479.conf
io_threads_active:0
listener0:name=tcp,bind=127.0.0.1,bind=-::1,port=6479

# Clients
connected_clients:3
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:20480
client_recent_max_output_buffer:20504
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
total_blocking_keys:0
total_blocking_keys_on_nokey:0

# Memory
used_memory:1367104
used_memory_human:1.30M
used_memory_rss:11272192
used_memory_rss_human:10.75M
used_memory_peak:1367104
used_memory_peak_human:1.30M
used_memory_peak_perc:100.13%
used_memory_overhead:1055036
used_memory_startup:866168
used_memory_dataset:312068
used_memory_dataset_perc:62.30%
allocator_allocated:1460104
allocator_active:1802240
allocator_resident:6975488
total_system_memory:3998314496
total_system_memory_human:3.72G
used_memory_lua:31744
used_memory_vm_eval:31744
used_memory_lua_human:31.00K
used_memory_scripts_eval:0
number_of_cached_scripts:0
number_of_functions:0
number_of_libraries:0
used_memory_vm_functions:32768
used_memory_vm_total:64512
used_memory_vm_total_human:63.00K
used_memory_functions:184
used_memory_scripts:184
used_memory_scripts_human:184B
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.23
allocator_frag_bytes:342136
allocator_rss_ratio:3.87
allocator_rss_bytes:5173248
rss_overhead_ratio:1.62
rss_overhead_bytes:4296704
mem_fragmentation_ratio:8.49
mem_fragmentation_bytes:9945104
mem_not_counted_for_evict:0
mem_replication_backlog:164036
mem_total_replication_buffers:164032
mem_clients_slaves:0
mem_clients_normal:24384
mem_cluster_links:0
mem_aof_buffer:0
mem_allocator:jemalloc-5.3.0
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0

# Persistence
loading:0
async_loading:0
current_cow_peak:0
current_cow_size:0
current_cow_size_age:0
current_fork_perc:0.00
current_save_keys_processed:0
current_save_keys_total:0
rdb_changes_since_last_save:5
rdb_bgsave_in_progress:0
rdb_last_save_time:1702424364
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
rdb_saves:0
rdb_last_cow_size:0
rdb_last_load_keys_expired:0
rdb_last_load_keys_loaded:0
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_rewrites:0
aof_rewrites_consecutive_failures:0
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0

# Stats
total_connections_received:18
total_commands_processed:5677
instantaneous_ops_per_sec:2
total_net_input_bytes:264328
total_net_output_bytes:1528896
total_net_repl_input_bytes:0
total_net_repl_output_bytes:147716
instantaneous_input_kbps:0.06
instantaneous_output_kbps:0.01
instantaneous_input_repl_kbps:0.00
instantaneous_output_repl_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:1
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:26
evicted_keys:0
evicted_clients:0
total_eviction_exceeded_time:0
current_eviction_exceeded_time:0
keyspace_hits:3
keyspace_misses:0
pubsub_channels:1
pubsub_patterns:0
pubsubshard_channels:0
latest_fork_usec:0
total_forks:0
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
total_active_defrag_time:0
current_active_defrag_time:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_error_replies:5
dump_payload_sanitizations:0
total_reads_processed:5589
total_writes_processed:5762
io_threaded_reads_processed:0
io_threaded_writes_processed:0
reply_buffer_shrinks:223
reply_buffer_expands:220
eventloop_cycles:27669
eventloop_duration_sum:2631414
eventloop_duration_cmd_sum:29350
instantaneous_eventloop_cycles_per_sec:11
instantaneous_eventloop_duration_usec:92
acl_access_denied_auth:0
acl_access_denied_cmd:0
acl_access_denied_key:0
acl_access_denied_channel:0

# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6480,state=online,offset=220365,lag=0
master_failover_state:no-failover
master_replid:704d8088fa70fd521224803398b1234479327f1f
master_replid2:585c0fa684a567dfa287ddca377357c3cbc0d695
master_repl_offset:220365
second_repl_offset:72650
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:72650
repl_backlog_histlen:147716

# CPU
used_cpu_sys:1.453671
used_cpu_user:1.860297
used_cpu_sys_children:0.000000
used_cpu_user_children:0.000000
used_cpu_sys_main_thread:1.452459
used_cpu_user_main_thread:1.859887

# Modules

# Errorstats
errorstat_NOAUTH:count=5

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=5,expires=0,avg_ttl=0
```