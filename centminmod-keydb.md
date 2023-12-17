```
keydb-server -v
KeyDB server v=6.3.4 sha=7e7e5e57:0 malloc=jemalloc-5.2.1 bits=64 build=8e0b8f8680ec0369
```
```
systemctl status keydb --no-pager -l | sed -e "s|$HOSTNAME|hostname|g"

● keydb.service - Advanced key-value store
   Loaded: loaded (/usr/lib/systemd/system/keydb.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/keydb.service.d
           └─limit.conf
   Active: active (running) since Thu 2023-12-14 05:00:04 UTC; 37min ago
     Docs: https://docs.keydb.dev,
           man:keydb-server(1)
  Process: 74607 ExecStop=/bin/kill -s TERM $MAINPID (code=exited, status=0/SUCCESS)
 Main PID: 74612 (keydb-server)
   Status: "Ready to accept connections"
    Tasks: 13 (limit: 23903)
   Memory: 4.5M
   CGroup: /system.slice/keydb.service
           └─74612 /usr/local/bin/keydb-server 127.0.0.1:7379

Dec 14 05:00:04 hostname systemd[1]: Starting Advanced key-value store...
Dec 14 05:00:04 hostname systemd[1]: Started Advanced key-value store.
```
```
keydb-server -h
Usage: ./keydb-server [/path/to/keydb.conf] [options] [-]
       ./keydb-server - (read config from stdin)
       ./keydb-server -v or --version
       ./keydb-server -h or --help
       ./keydb-server --test-memory <megabytes>

Examples:
       ./keydb-server (run the server with default conf)
       ./keydb-server /etc/keydb/6379.conf
       ./keydb-server --port 7777
       ./keydb-server --port 7777 --replicaof 127.0.0.1 8888
       ./keydb-server /etc/mykeydb.conf --loglevel verbose -
       ./keydb-server /etc/mykeydb.conf --loglevel verbose

Sentinel mode:
       ./keydb-server /etc/sentinel.conf --sentinel
```
```
keydb-sentinel -h
Usage: ./keydb-server [/path/to/keydb.conf] [options] [-]
       ./keydb-server - (read config from stdin)
       ./keydb-server -v or --version
       ./keydb-server -h or --help
       ./keydb-server --test-memory <megabytes>

Examples:
       ./keydb-server (run the server with default conf)
       ./keydb-server /etc/keydb/6379.conf
       ./keydb-server --port 7777
       ./keydb-server --port 7777 --replicaof 127.0.0.1 8888
       ./keydb-server /etc/mykeydb.conf --loglevel verbose -
       ./keydb-server /etc/mykeydb.conf --loglevel verbose

Sentinel mode:
       ./keydb-server /etc/sentinel.conf --sentinel
```
```
checksec --file=$(which keydb-server) --format=json | jq -r
{
  "/usr/local/bin/keydb-server": {
    "relro": "full",
    "canary": "yes",
    "nx": "no",
    "pie": "yes",
    "rpath": "no",
    "runpath": "no",
    "symbols": "yes",
    "fortify_source": "yes",
    "fortified": "11",
    "fortify-able": "26"
  }
}
```
```
keydb-cli -p 7379 info
# Server
redis_version:6.3.4
redis_git_sha1:7e7e5e57
redis_git_dirty:0
redis_build_id:8e0b8f8680ec0369
redis_mode:standalone
os:Linux 4.18.0-477.27.2.el8_8.x86_64 x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:11.2.1
process_id:78054
process_supervised:systemd
run_id:34995c484792a84ae5ae5b8ce79b8d7d2673c403
tcp_port:7379
server_time_usec:1702564566142608
uptime_in_seconds:28646
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:8065750
executable:/usr/local/bin/keydb-server
config_file:/etc/keydb/keydb.conf
availability_zone:
features:cluster_mget

# Clients
connected_clients:1
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:0
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
current_client_thread:0
thread_0_clients:1
thread_1_clients:0

# Memory
used_memory:69355280
used_memory_human:66.14M
used_memory_rss:84082688
used_memory_rss_human:80.19M
used_memory_peak:73544864
used_memory_peak_human:70.14M
used_memory_peak_perc:94.30%
used_memory_overhead:35664920
used_memory_startup:2004504
used_memory_dataset:33690360
used_memory_dataset_perc:50.02%
allocator_allocated:69735592
allocator_active:71081984
allocator_resident:75075584
total_system_memory:3998314496
total_system_memory_human:3.72G
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.02
allocator_frag_bytes:1346392
allocator_rss_ratio:1.06
allocator_rss_bytes:3993600
rss_overhead_ratio:1.12
rss_overhead_bytes:9007104
mem_fragmentation_ratio:1.21
mem_fragmentation_bytes:14791200
mem_not_counted_for_evict:0
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:0
mem_aof_buffer:0
mem_allocator:jemalloc-5.2.1
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0
storage_provider:none
available_system_memory:unavailable

# Persistence
loading:0
current_cow_size:0
current_cow_size_age:0
current_fork_perc:0.00
current_save_keys_processed:0
current_save_keys_total:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1702548097
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:966656
aof_enabled:0
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0

# Stats
total_connections_received:1633
total_commands_processed:33024335
instantaneous_ops_per_sec:0
total_net_input_bytes:1145874838
total_net_output_bytes:236386727
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:231
evicted_keys:0
keyspace_hits:11518840
keyspace_misses:1983914
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:2254
total_forks:11
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_error_replies:6
dump_payload_sanitizations:0
total_reads_processed:9115994
total_writes_processed:9114361
instantaneous_lock_contention:1
avg_lock_contention:0.000000
storage_provider_read_hits:0
storage_provider_read_misses:0

# Replication
role:master
connected_slaves:0
master_failover_state:no-failover
master_replid:d2c898ed02e6e50a1ddf1da86f068b5096cd2d2f
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:109.192300
used_cpu_user:107.051355
used_cpu_sys_children:0.066978
used_cpu_user_children:0.680582
server_threads:2
long_lock_waits:0
used_cpu_sys_main_thread:52.958606
used_cpu_user_main_thread:71.208860

# Modules

# Errorstats
errorstat_ERR:count=6

# Cluster
cluster_enabled:0

# Keyspace
db0:keys=526496,expires=0,avg_ttl=0,cached_keys=526496

# KeyDB
mvcc_depth:0
```

## info explained

- **Server Section**
  - `redis_version`: The version of Redis server.
  - `redis_git_sha1`: The Git SHA1 hash of the Redis server source code.
  - `redis_git_dirty`: Indicates if the Git repository had modified files (0 for no, 1 for yes).
  - `redis_build_id`: A unique identifier for the Redis server build.
  - `redis_mode`: Operating mode of Redis (e.g., standalone, cluster).
  - `os`: Operating system and version.
  - `arch_bits`: Architecture bits (e.g., 32 or 64).
  - `multiplexing_api`: The event multiplexing API used.
  - `atomicvar_api`: The atomic variables API used.
  - `gcc_version`: Version of the GCC compiler used.
  - `process_id`: Process ID of the Redis server.
  - `process_supervised`: Supervision system used (e.g., systemd).
  - `run_id`: Unique identifier of the server run.
  - `tcp_port`: TCP port on which Redis is running.
  - `server_time_usec`: Server time in microseconds.
  - `uptime_in_seconds`: Server uptime in seconds.
  - `uptime_in_days`: Server uptime in days.
  - `hz`: Server frequency for internal tasks.
  - `configured_hz`: Configured server frequency.
  - `lru_clock`: Clock value for LRU management.
  - `executable`: Path to the Redis server executable.
  - `config_file`: Path to the Redis configuration file.
  - `availability_zone`: Availability zone of the server.
  - `features`: Enabled features like cluster_mget.

- **Clients Section**
  - `connected_clients`: Number of client connections.
  - `cluster_connections`: Number of connections in the cluster.
  - `maxclients`: Maximum number of clients allowed.
  - `client_recent_max_input_buffer`: Largest input buffer among recent clients.
  - `client_recent_max_output_buffer`: Largest output buffer among recent clients.
  - `blocked_clients`: Number of clients blocked by certain commands.
  - `tracking_clients`: Number of clients being tracked.
  - `clients_in_timeout_table`: Number of clients in the timeout table.
  - `current_client_thread`: Current client thread number.
  - `thread_0_clients`: Number of clients in thread 0.
  - `thread_1_clients`: Number of clients in thread 1.

- **Memory Section**
  - `used_memory`: Total memory used by Redis in bytes.
  - `used_memory_human`: Human-readable format of used memory.
  - `used_memory_rss`: Resident Set Size memory used.
  - `used_memory_rss_human`: Human-readable RSS memory used.
  - `used_memory_peak`: Peak memory consumed by Redis.
  - `used_memory_peak_human`: Human-readable peak memory.
  - `used_memory_peak_perc`: Percentage of peak used memory.
  - `used_memory_overhead`: Overhead used by Redis for internal mechanisms.
  - `used_memory_startup`: Memory used at startup.
  - `used_memory_dataset`: Memory used for storing data.
  - `used_memory_dataset_perc`: Percentage of memory used for data.
  - `allocator_allocated`: Memory allocated by the allocator.
  - `allocator_active`: Active memory in the allocator.
  - `allocator_resident`: Resident size in the allocator.
  - `total_system_memory`: Total memory available in the system.
  - `total_system_memory_human`: Human-readable total system memory.
  - `used_memory_lua`: Memory used by the Lua engine.
  - `used_memory_lua_human`: Human-readable Lua memory usage.
  - `used_memory_scripts`: Memory used by scripts.
  - `used_memory_scripts_human`: Human-readable script memory usage.
  - `number_of_cached_scripts`: Number of scripts cached.
  - `maxmemory`: Maximum memory limit set.
  - `maxmemory_human`: Human-readable maximum memory limit.
  - `maxmemory_policy`: Eviction policy when maxmemory is reached.
  - `allocator_frag_ratio`: Fragmentation ratio of the allocator.
  - `allocator_frag_bytes`: Fragmentation bytes in the allocator.
  - `allocator_rss_ratio`: RSS ratio of the allocator.
  - `allocator_rss_bytes`: RSS bytes in the allocator.
  - `rss_overhead_ratio`: Ratio of RSS overhead.
  - `rss_overhead_bytes`: Bytes of RSS overhead.
  - `mem_fragmentation_ratio`: Memory fragmentation ratio.
  - `mem_fragmentation_bytes`: Bytes of memory fragmentation.
  - `mem_not_counted_for_evict`: Memory not counted for eviction.
  - `mem_replication_backlog`: Size of replication backlog.
  - `mem_clients_slaves`: Memory used by slave clients.
  - `mem_clients_normal`: Memory used by normal clients.
  - `mem_aof_buffer`: Memory used by AOF buffer.
  - `mem_allocator`: Memory allocator being used.
  - `active_defrag_running`: Indicates if active defragmentation is running.
  - `lazyfree_pending_objects`: Pending objects for lazy freeing.
  - `lazyfreed_objects`: Number of objects lazy freed.
  - `storage_provider`: Storage provider used.
  - `available_system_memory`: Available system memory.

- **Persistence Section**
  - `loading`: Indicates if the database is loading from disk.
  - `current_cow_size`: Size of copy-on-write memory during last operation.
  - `current_cow_size_age`: Age of the current copy-on-write size.
  - `current_fork_perc`: Percentage of the last fork operation completed.
  - `current_save_keys_processed`: Keys processed in the current save.
  - `current_save_keys_total`: Total keys to process in the current save.
  - `rdb_changes_since_last_save`: Changes since the last RDB save.
  - `rdb_bgsave_in_progress`: Indicates if a background save is in progress.
  - `rdb_last_save_time`: Timestamp of the last RDB save.
  - `rdb_last_bgsave_status`: Status of the last background save.
  - `rdb_last_bgsave_time_sec`: Time taken for the last background save.
  - `rdb_current_bgsave_time_sec`: Time for the current background save.
  - `rdb_last_cow_size`: Size of the last copy-on-write operation.
  - `aof_enabled`: Indicates if AOF (Append Only File) is enabled.
  - `aof_rewrite_in_progress`: Indicates if an AOF rewrite is in progress.
  - `aof_rewrite_scheduled`: Indicates if an AOF rewrite is scheduled.
  - `aof_last_rewrite_time_sec`: Time taken for the last AOF rewrite.
  - `aof_current_rewrite_time_sec`: Time for the current AOF rewrite.
  - `aof_last_bgrewrite_status`: Status of the last AOF background rewrite.
  - `aof_last_write_status`: Status of the last AOF write.
  - `aof_last_cow_size`: Size of the last AOF copy-on-write operation.
  - `module_fork_in_progress`: Indicates if a module fork is in progress.
  - `module_fork_last_cow_size`: Last copy-on-write size for a module fork.

- **Stats Section**
  - `total_connections_received`: Total number of connections received.
  - `total_commands_processed`: Total number of commands processed.
  - `instantaneous_ops_per_sec`: Operations per second currently executed.
  - `total_net_input_bytes`: Total number of bytes received.
  - `total_net_output_bytes`: Total number of bytes sent.
  - `instantaneous_input_kbps`: Network input rate in KB per second.
  - `instantaneous_output_kbps`: Network output rate in KB per second.
  - `rejected_connections`: Number of connections rejected.
  - `sync_full`: Number of full syncs with replicas.
  - `sync_partial_ok`: Number of successful partial syncs.
  - `sync_partial_err`: Number of partial syncs with errors.
  - `expired_keys`: Number of expired keys.
  - `expired_stale_perc`: Percentage of expired stale keys.
  - `expired_time_cap_reached_count`: Counts when expiration time cap is reached.
  - `expire_cycle_cpu_milliseconds`: CPU time spent in expiration cycles.
  - `evicted_keys`: Number of keys evicted.
  - `keyspace_hits`: Number of successful lookups in the main dictionary.
  - `keyspace_misses`: Number of failed lookups in the main dictionary.
  - `pubsub_channels`: Number of active Pub/Sub channels.
  - `pubsub_patterns`: Number of active Pub/Sub patterns.
  - `latest_fork_usec`: Duration of the latest fork operation in microseconds.
  - `total_forks`: Total number of fork operations.
  - `migrate_cached_sockets`: Number of cached sockets in migrate.
  - `slave_expires_tracked_keys`: Tracked keys for slave expiration.
  - `active_defrag_hits`: Hits during active defragmentation.
  - `active_defrag_misses`: Misses during active defragmentation.
  - `active_defrag_key_hits`: Key hits during active defragmentation.
  - `active_defrag_key_misses`: Key misses during active defragmentation.
  - `tracking_total_keys`: Total number of keys tracked.
  - `tracking_total_items`: Total number of items tracked.
  - `tracking_total_prefixes`: Total number of prefixes tracked.
  - `unexpected_error_replies`: Number of unexpected error replies.
  - `total_error_replies`: Total number of error replies.
  - `dump_payload_sanitizations`: Number of dump payload sanitizations.
  - `total_reads_processed`: Total number of read operations processed.
  - `total_writes_processed`: Total number of write operations processed.
  - `instantaneous_lock_contention`: The current number of lock contentions.
  - `avg_lock_contention`: The average number of lock contentions.
  - `storage_provider_read_hits`: Number of successful read operations from the storage provider.
  - `storage_provider_read_misses`: Number of read operations that failed to retrieve data from the storage provider.

- **Replication Section**
  - `role`: The role of the server in the replication setup, such as master.
  - `connected_slaves`: Number of slave servers connected to this master.
  - `master_failover_state`: The state of failover in the master-slave setup.
  - `master_replid`: A unique identifier for the master replication.
  - `master_replid2`: A secondary replication ID for the master.
  - `master_repl_offset`: The offset in the replication stream.
  - `second_repl_offset`: The offset for a secondary replication stream.
  - `repl_backlog_active`: Indicates if the replication backlog is active.
  - `repl_backlog_size`: Size of the replication backlog.
  - `repl_backlog_first_byte_offset`: The offset of the first byte in the replication backlog.
  - `repl_backlog_histlen`: Length of the historical data in the replication backlog.

- **CPU Section**
  - `used_cpu_sys`: Total system CPU time used.
  - `used_cpu_user`: Total user CPU time used.
  - `used_cpu_sys_children`: System CPU time used by child processes.
  - `used_cpu_user_children`: User CPU time used by child processes.
  - `server_threads`: Number of server threads.
  - `long_lock_waits`: Number of long lock waits.
  - `used_cpu_sys_main_thread`: System CPU time used by the main thread.
  - `used_cpu_user_main_thread`: User CPU time used by the main thread.

- **Modules Section**
  - This section will list any modules loaded into the KeyDB instance, but it appears to be empty in this case.

- **Errorstats Section**
  - `errorstat_ERR`: An object containing error statistics, in this case, the count of ERR errors.

- **Cluster Section**
  - `cluster_enabled`: Indicates if the cluster mode is enabled (1 for enabled, 0 for disabled).

- **Keyspace Section**
  - `db0`: Information about database 0, including the number of keys, how many have expiration set, the average time-to-live (TTL) for keys, and the number of cached keys.

- **KeyDB Specific**
  - `mvcc_depth`: The depth of Multi-Version Concurrency Control, specific to KeyDB.

```
keydb-cli -p 7379 CONFIG GET "*"
  1) "rdbchecksum"
  2) "yes"
  3) "daemonize"
  4) "no"
  5) "lua-replicate-commands"
  6) "yes"
  7) "always-show-logo"
  8) "yes"
  9) "enable-motd"
 10) "yes"
 11) "protected-mode"
 12) "yes"
 13) "rdbcompression"
 14) "yes"
 15) "rdb-del-sync-files"
 16) "no"
 17) "activerehashing"
 18) "yes"
 19) "stop-writes-on-bgsave-error"
 20) "yes"
 21) "set-proc-title"
 22) "yes"
 23) "dynamic-hz"
 24) "yes"
 25) "lazyfree-lazy-eviction"
 26) "no"
 27) "lazyfree-lazy-expire"
 28) "no"
 29) "lazyfree-lazy-server-del"
 30) "no"
 31) "lazyfree-lazy-user-del"
 32) "no"
 33) "lazyfree-lazy-user-flush"
 34) "no"
 35) "repl-disable-tcp-nodelay"
 36) "no"
 37) "repl-diskless-sync"
 38) "no"
 39) "aof-rewrite-incremental-fsync"
 40) "yes"
 41) "no-appendfsync-on-rewrite"
 42) "no"
 43) "cluster-require-full-coverage"
 44) "yes"
 45) "rdb-save-incremental-fsync"
 46) "yes"
 47) "aof-load-truncated"
 48) "yes"
 49) "aof-use-rdb-preamble"
 50) "yes"
 51) "cluster-replica-no-failover"
 52) "no"
 53) "cluster-slave-no-failover"
 54) "no"
 55) "replica-lazy-flush"
 56) "no"
 57) "slave-lazy-flush"
 58) "no"
 59) "replica-serve-stale-data"
 60) "yes"
 61) "slave-serve-stale-data"
 62) "yes"
 63) "replica-read-only"
 64) "yes"
 65) "slave-read-only"
 66) "yes"
 67) "replica-ignore-maxmemory"
 68) "yes"
 69) "slave-ignore-maxmemory"
 70) "yes"
 71) "jemalloc-bg-thread"
 72) "yes"
 73) "activedefrag"
 74) "no"
 75) "syslog-enabled"
 76) "no"
 77) "cluster-enabled"
 78) "no"
 79) "appendonly"
 80) "no"
 81) "cluster-allow-reads-when-down"
 82) "no"
 83) "delete-on-evict"
 84) "no"
 85) "use-fork"
 86) "yes"
 87) "io-threads-do-reads"
 88) "no"
 89) "time-thread-priority"
 90) "no"
 91) "prefetch-enabled"
 92) "yes"
 93) "allow-rdb-resize-op"
 94) "yes"
 95) "crash-log-enabled"
 96) "yes"
 97) "crash-memcheck-enabled"
 98) "yes"
 99) "use-exit-on-panic"
100) "no"
101) "disable-thp"
102) "yes"
103) "cluster-allow-replica-migration"
104) "yes"
105) "replica-announced"
106) "yes"
107) "enable-async-commands"
108) "no"
109) "multithread-load-enabled"
110) "no"
111) "active-client-balancing"
112) "yes"
113) "aclfile"
114) ""
115) "unixsocket"
116) ""
117) "pidfile"
118) "/var/run/keydb/keydb_7379.pid"
119) "replica-announce-ip"
120) ""
121) "slave-announce-ip"
122) ""
123) "masteruser"
124) ""
125) "cluster-announce-ip"
126) ""
127) "syslog-ident"
128) "redis"
129) "dbfilename"
130) "dump.rdb"
131) "db-s3-object"
132) ""
133) "appendfilename"
134) "appendonly.aof"
135) "server_cpulist"
136) ""
137) "bio_cpulist"
138) ""
139) "aof_rewrite_cpulist"
140) ""
141) "bgsave_cpulist"
142) ""
143) "storage-provider-options"
144) ""
145) "ignore-warnings"
146) ""
147) "proc-title-template"
148) "{title} {listen-addr} {server-mode}"
149) "masterauth"
150) ""
151) "requirepass"
152) ""
153) "supervised"
154) "systemd"
155) "syslog-facility"
156) "local0"
157) "repl-diskless-load"
158) "disabled"
159) "loglevel"
160) "notice"
161) "maxmemory-policy"
162) "noeviction"
163) "appendfsync"
164) "everysec"
165) "storage-cache-mode"
166) "writethrough"
167) "oom-score-adj"
168) "no"
169) "acl-pubsub-default"
170) "allchannels"
171) "sanitize-dump-payload"
172) "no"
173) "databases"
174) "16"
175) "port"
176) "7379"
177) "auto-aof-rewrite-percentage"
178) "100"
179) "cluster-replica-validity-factor"
180) "10"
181) "cluster-slave-validity-factor"
182) "10"
183) "list-max-ziplist-size"
184) "-2"
185) "tcp-keepalive"
186) "300"
187) "cluster-migration-barrier"
188) "1"
189) "active-defrag-cycle-min"
190) "1"
191) "active-defrag-cycle-max"
192) "25"
193) "active-defrag-threshold-lower"
194) "10"
195) "active-defrag-threshold-upper"
196) "100"
197) "lfu-log-factor"
198) "10"
199) "lfu-decay-time"
200) "1"
201) "replica-priority"
202) "100"
203) "slave-priority"
204) "100"
205) "repl-diskless-sync-delay"
206) "5"
207) "maxmemory-samples"
208) "16"
209) "maxmemory-eviction-tenacity"
210) "10"
211) "timeout"
212) "0"
213) "replica-announce-port"
214) "0"
215) "slave-announce-port"
216) "0"
217) "tcp-backlog"
218) "65535"
219) "cluster-announce-bus-port"
220) "0"
221) "cluster-announce-port"
222) "0"
223) "cluster-announce-tls-port"
224) "0"
225) "repl-timeout"
226) "60"
227) "repl-ping-replica-period"
228) "10"
229) "repl-ping-slave-period"
230) "10"
231) "list-compress-depth"
232) "0"
233) "rdb-key-save-delay"
234) "0"
235) "key-load-delay"
236) "0"
237) "active-expire-effort"
238) "1"
239) "hz"
240) "10"
241) "min-replicas-to-write"
242) "0"
243) "min-slaves-to-write"
244) "0"
245) "min-replicas-max-lag"
246) "10"
247) "min-slaves-max-lag"
248) "10"
249) "min-clients-per-thread"
250) "20"
251) "storage-flush-period"
252) "500"
253) "replica-quorum"
254) "-1"
255) "replica-weighting-factor"
256) "2"
257) "maxclients"
258) "10000"
259) "loading-process-events-interval-keys"
260) "8192"
261) "maxclients-reserved"
262) "0"
263) "active-defrag-max-scan-fields"
264) "1000"
265) "slowlog-max-len"
266) "128"
267) "acllog-max-len"
268) "128"
269) "lua-time-limit"
270) "5000"
271) "cluster-node-timeout"
272) "15000"
273) "slowlog-log-slower-than"
274) "10000"
275) "latency-monitor-threshold"
276) "0"
277) "proto-max-bulk-len"
278) "536870912"
279) "stream-node-max-entries"
280) "100"
281) "repl-backlog-size"
282) "1048576"
283) "repl-backlog-disk-reserve"
284) "0"
285) "max-snapshot-slip"
286) "400"
287) "max-rand-count"
288) "4611686018427387903"
289) "maxmemory"
290) "0"
291) "maxstorage"
292) "0"
293) "hash-max-ziplist-entries"
294) "512"
295) "set-max-intset-entries"
296) "512"
297) "zset-max-ziplist-entries"
298) "128"
299) "active-defrag-ignore-bytes"
300) "104857600"
301) "hash-max-ziplist-value"
302) "64"
303) "stream-node-max-bytes"
304) "4096"
305) "zset-max-ziplist-value"
306) "64"
307) "hll-sparse-max-bytes"
308) "3000"
309) "tracking-table-max-keys"
310) "1000000"
311) "client-query-buffer-limit"
312) "1073741824"
313) "repl-backlog-ttl"
314) "3600"
315) "auto-aof-rewrite-min-size"
316) "67108864"
317) "loading-process-events-interval-bytes"
318) "2097152"
319) "multi-master-no-forward"
320) "no"
321) "allow-write-during-load"
322) "no"
323) "force-backlog-disk-reserve"
324) "no"
325) "soft-shutdown"
326) "no"
327) "flash-disable-key-cache"
328) "no"
329) "semi-ordered-set-bucket-size"
330) "0"
331) "availability-zone"
332) ""
333) "overload-protect-percent"
334) "0"
335) "force-eviction-percent"
336) "0"
337) "enable-async-rehash"
338) "yes"
339) "enable-keydb-fastsync"
340) "no"
341) "tls-port"
342) "0"
343) "tls-session-cache-size"
344) "20480"
345) "tls-session-cache-timeout"
346) "300"
347) "tls-cluster"
348) "no"
349) "tls-replication"
350) "no"
351) "tls-auth-clients"
352) "yes"
353) "tls-prefer-server-ciphers"
354) "no"
355) "tls-session-caching"
356) "yes"
357) "tls-rotation"
358) "no"
359) "tls-cert-file"
360) ""
361) "tls-key-file"
362) ""
363) "tls-key-file-pass"
364) ""
365) "tls-client-cert-file"
366) ""
367) "tls-client-key-file"
368) ""
369) "tls-client-key-file-pass"
370) ""
371) "tls-dh-params-file"
372) ""
373) "tls-ca-cert-file"
374) ""
375) "tls-ca-cert-dir"
376) ""
377) "tls-protocols"
378) ""
379) "tls-ciphers"
380) ""
381) "tls-ciphersuites"
382) ""
383) "logfile"
384) "/var/log/keydb/keydb.log"
385) "watchdog-period"
386) "0"
387) "dir"
388) "/var/lib/keydb"
389) "save"
390) "900 1 300 10 60 10000"
391) "client-output-buffer-limit"
392) "normal 0 0 0 slave 268435456 67108864 60 pubsub 33554432 8388608 60"
393) "unixsocketperm"
394) "0"
395) "slaveof"
396) ""
397) "notify-keyspace-events"
398) ""
399) "bind"
400) "127.0.0.1 -::1"
401) "oom-score-adj-values"
402) "0 200 800"
403) "active-replica"
404) "no"
405) "tls-allowlist"
406) (empty array)
```

* https://docs.keydb.dev/docs/clients#client-command

```
keydb-cli -p 7379 client list

id=1608 addr=127.0.0.1:3708 laddr=127.0.0.1:7379 fd=16 name= age=0 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=40954 argv-mem=10 obl=0 oll=0 omem=0 tot-mem=61466 events=r cmd=client user=default redir=-1
```

* addr: The client address, that is, the client IP and the remote port number it used to connect with the KeyDB server.
* fd: The client socket file descriptor number.
* name: The client name as set by CLIENT SETNAME.
* age: The number of seconds the connection existed for.
* idle: The number of seconds the connection is idle.
* flags: The kind of client (N means normal client, check the full list of flags).
* omem: The amount of memory used by the client for the output buffer.
* cmd: The last executed command.

* https://docs.keydb.dev/docs/keydbcli#continuous-stats-mode

```
keydb-cli -p 7379 --stat

------- data ------ --------------------- load -------------------- - child -
keys       mem      clients blocked requests            connections          
37735      21.35M   1       0       9016263 (+0)        1606        
37735      21.35M   1       0       9016264 (+1)        1606        
37735      21.31M   1       0       9016265 (+1)        1606        
37735      21.35M   1       0       9016266 (+1)        1606        
37735      21.35M   1       0       9016267 (+1)        1606        
37735      21.35M   1       0       9016268 (+1)        1606        
37735      21.35M   1       0       9016269 (+1)        1606 
```

* https://docs.keydb.dev/docs/keydbcli#getting-a-list-of-keys

```
keydb-cli -p 7379 --scan | head -10

memtier-1606458
memtier-6479553
memtier-2941025
memtier-2185768
memtier-5764374
memtier-2183674
memtier-8892962
memtier-5465745
memtier-3102119
memtier-770598
```

* https://docs.keydb.dev/docs/keydbcli#monitoring-the-latency-of-keydb-instances

```
keydb-cli -p 7379 --latency

min: 0, max: 30, avg: 0.13 (1995 samples
```

```
keydb-cli -p 7379 --intrinsic-latency 5

Max latency so far: 1 microseconds.
Max latency so far: 51 microseconds.
Max latency so far: 85 microseconds.
Max latency so far: 89 microseconds.
Max latency so far: 1973 microseconds.
Max latency so far: 2218 microseconds.

83769366 total runs (avg latency: 0.0597 microseconds / 59.69 nanoseconds per run).
Worst run took 37160x longer than the average latency.
```

* https://docs.keydb.dev/docs/keydbcli#performing-an-lru-simulation

```
keydb-cli -p 7379 --lru-test 100000

202500 Gets/sec | Hits: 163611 (80.80%) | Misses: 38889 (19.20%)
212750 Gets/sec | Hits: 205915 (96.79%) | Misses: 6835 (3.21%)
203500 Gets/sec | Hits: 200112 (98.34%) | Misses: 3388 (1.66%)
219000 Gets/sec | Hits: 216539 (98.88%) | Misses: 2461 (1.12%)
207250 Gets/sec | Hits: 205562 (99.19%) | Misses: 1688 (0.81%)
209000 Gets/sec | Hits: 207689 (99.37%) | Misses: 1311 (0.63%)
220000 Gets/sec | Hits: 218808 (99.46%) | Misses: 1192 (0.54%)
213000 Gets/sec | Hits: 212051 (99.55%) | Misses: 949 (0.45%)
221000 Gets/sec | Hits: 220160 (99.62%) | Misses: 840 (0.38%)
201000 Gets/sec | Hits: 200295 (99.65%) | Misses: 705 (0.35%)
210750 Gets/sec | Hits: 210147 (99.71%) | Misses: 603 (0.29%)
```

## KeyDB Diagnostic Tool

* https://docs.keydb.dev/docs/keydbdiagnostictool

```
keydb-diagnostic-tool -h 127.0.0.1 -p 7379 2>&1 | tee keydb-dignostic1.log

Server has 2 threads.
Starting...
1 threads, 50 total clients. CPU Usage Self: 98.9% (98.9% per thread), Serve2 threads, 100 total clients. CPU Usage Self: 197.4% (98.7% per thread), Ser3 threads, 150 total clients. CPU Usage Self: 279.3% (93.1% per thread), Ser4 threads, 200 total clients. CPU Usage Self: 269.9% (67.5% per thread), Ser5 threads, 250 total clients. CPU Usage Self: 374.1% (74.8% per thread), SerError: ��������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������

Server CPU load appears to have stagnated with increasing clients.
Server does not appear to be at full load. Check network for throughput.
Done.
```

# Benchmarks

`memtier_benchmark` comparing Redis 7.2.3 with default `io-threads` 1 and 2 vs KeyDB 6.3.4 for 1, 2, 3 and 8 threads on 4 CPU core KVM VPS running AlmaLinux 8 with Centmin Mod 130.00beta01 LEMP stack. Added KeyDB server config raising `server-threads` from `2` to `4`.

| KV Databases | Threads | Sets (ops/sec) | Gets (ops/sec) | Totals (ops/sec) | vs Redis 2 threads Sets | vs Redis 2 threads Gets |
|-|-|-|-|-|-|-|
| KeyDB 6.3.4 server-threads=4 | 1 | 9818.99 | 147284.89 | 157103.88 | 0.95x | 0.95x |
| KeyDB 6.3.4 server-threads=4 | 2 | 21434.70 | 321520.53 | 342955.23 | 2.07x | 2.07x |
| KeyDB 6.3.4 server-threads=4 | 3 | 29326.45 | 439896.80 | 469223.26 | 2.84x | 2.84x |
| KeyDB 6.3.4 server-threads=4 | 8 | 23136.90 | 347053.44 | 370190.33 | 2.24x | 2.24x |
| KeyDB 6.3.4 server-threads=2 | 1 | 7770.48 | 116557.14 | 124327.62 | 0.75x | 0.75x |
| KeyDB 6.3.4 server-threads=2 | 2 | 14650.89 | 219763.35 | 234414.24 | 1.42x | 1.42x |
| KeyDB 6.3.4 server-threads=2 | 3 | 16959.49 | 254392.40 | 271351.89 | 1.64x | 1.64x |
| KeyDB 6.3.4 server-threads=2 | 8 | 22175.40 | 332631.04 | 354806.44 | 2.14x | 2.14x |
| Redis 7.2.3 io-threads 1 | 1 | 7404.66 | 111069.97 | 118474.64 | - | - |
| Redis 7.2.3 io-threads 1 | 2 | 10338.26 | 155073.83 | 165412.08 | - | - |
| Redis 7.2.3 io-threads 1 | 3 | 6660.16 | 99902.42 | 106562.59 | - | - |
| Redis 7.2.3 io-threads 1 | 8 | 10177.75 | 152666.27 | 162844.02 | - | - |
| Redis 7.2.3 io-threads 2 | 1 | 7886.29 | 118294.40 | 126180.69 | - | - |
| Redis 7.2.3 io-threads 2 | 2 | 14104.89 | 211573.37 | 225678.26 | - | - |
| Redis 7.2.3 io-threads 2 | 3 | 13244.12 | 198661.73 | 211905.85 | - | - |
| Redis 7.2.3 io-threads 2 | 8 | 12750.31 | 191254.59 | 204004.90 | - | - |

```
lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  1
Core(s) per socket:  1
Socket(s):           4
NUMA node(s):        1
Vendor ID:           AuthenticAMD
BIOS Vendor ID:      QEMU
CPU family:          25
Model:               1
Model name:          AMD EPYC-Milan Processor
BIOS Model name:     pc-i440fx-focal
Stepping:            1
CPU MHz:             2645.030
BogoMIPS:            5290.06
Virtualization:      AMD-V
Hypervisor vendor:   KVM
Virtualization type: full
L1d cache:           32K
L1i cache:           32K
L2 cache:            512K
L3 cache:            32768K
NUMA node0 CPU(s):   0-3
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm rep_good nopl cpuid extd_apicid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm svm cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw topoext perfctr_core invpcid_single ssbd ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 erms invpcid rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves clzero xsaveerptr wbnoinvd arat npt nrip_save umip pku ospke rdpid fsrm
```
```
free -mlt
              total        used        free      shared  buff/cache   available
Mem:           3813        1604        1377          90         831        1754
Low:           3813        2435        1377
High:             0           0           0
Swap:          4095        1702        2393
Total:         7909        3306        3771
```
```
cat /etc/os-release 
NAME="AlmaLinux"
VERSION="8.9 (Midnight Oncilla)"
ID="almalinux"
ID_LIKE="rhel centos fedora"
VERSION_ID="8.9"
PLATFORM_ID="platform:el8"
PRETTY_NAME="AlmaLinux 8.9 (Midnight Oncilla)"
ANSI_COLOR="0;34"
LOGO="fedora-logo-icon"
CPE_NAME="cpe:/o:almalinux:almalinux:8::baseos"
HOME_URL="https://almalinux.org/"
DOCUMENTATION_URL="https://wiki.almalinux.org/"
BUG_REPORT_URL="https://bugs.almalinux.org/"

ALMALINUX_MANTISBT_PROJECT="AlmaLinux-8"
ALMALINUX_MANTISBT_PROJECT_VERSION="8.9"
REDHAT_SUPPORT_PRODUCT="AlmaLinux"
REDHAT_SUPPORT_PRODUCT_VERSION="8.9"
```

## KeyDB benchmark - 8 thread with `server-threads = 4`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 8 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 14%,   0 secs]  8 threads:      231631 ops,  231874 (avg:  231874) ops[RUN #1 29%,   1 secs]  8 threads:      463918 ops,  232084 (avg:  231979) ops[RUN #1 44%,   3 secs]  8 threads:      696842 ops,  231749 (avg:  231902) ops[RUN #1 58%,   4 secs]  8 threads:      922796 ops,  225893 (avg:  230401) ops[RUN #1 72%,   4 secs]  8 threads:     1144751 ops,  228648 (avg:  230059) ops[RUN #1 86%,   5 secs]  8 threads:     1377220 ops,  308804 (avg:  240407) ops[RUN #1 100%,   6 secs]  0 threads:     1600000 ops,  308804 (avg:  263214) ops/sec, 19.99MB/sec (avg: 17.06MB/sec),  2.61 (avg:  3.04) msec latency

8         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        23136.90          ---          ---         3.05558         2.09500        17.40700        39.93500      9758.42 
Gets       347053.44      3431.43    343622.00         3.03794         2.06300        17.53500        39.67900     14816.10 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     370190.33      3431.43    343622.00         3.03904         2.06300        17.53500        39.67900     24574.51 
```

## KeyDB benchmark - 1 thread with `server-threads = 4`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 1 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 64%,   0 secs]  1 threads:      128573 ops,  128641 (avg:  128641) ops[RUN #1 100%,   1 secs]  0 threads:      200000 ops,  128641 (avg:  157106) ops/sec, 7.97MB/sec (avg: 9.72MB/sec),  0.78 (avg:  0.64) msec latency

1         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets         9818.99          ---          ---         0.64477         0.53500        10.23900        11.19900      4141.33 
Gets       147284.89       187.74    147097.15         0.63606         0.52700        10.87900        11.19900      5808.31 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     157103.88       187.74    147097.15         0.63660         0.52700        10.87900        11.19900      9949.63
```

## KeyDB benchmark - 2 threads with `server-threads = 4`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 2 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 45%,   0 secs]  2 threads:      181451 ops,  184198 (avg:  184198) ops[RUN #1 78%,   1 secs]  2 threads:      313023 ops,  182823 (avg:  183618) ops[RUN #1 99%,   2 secs]  1 threads:      397001 ops,  182823 (avg:  192182) ops[RUN #1 100%,   2 secs]  0 threads:      400000 ops,  182823 (avg:  193350) ops/sec, 11.35MB/sec (avg: 12.01MB/sec),  1.09 (avg:  1.03) msec latency

2         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        21434.70          ---          ---         1.04704         0.55100        11.58300        21.37500      9040.48 
Gets       321520.53       637.04    320883.49         1.03336         0.53500        11.39100        22.14300     12765.32 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     342955.23       637.04    320883.49         1.03422         0.53500        11.39100        22.14300     21805.80 
```

## KeyDB benchmark - 3 threads with `server-threads = 4`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 3 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 41%,   0 secs]  3 threads:      247753 ops,  248006 (avg:  248006) ops[RUN #1 83%,   1 secs]  3 threads:      497103 ops,  283776 (avg:  264745) ops[RUN #1 100%,   2 secs]  0 threads:      600000 ops,  283776 (avg:  285430) ops/sec, 17.77MB/sec (avg: 17.89MB/sec),  1.06 (avg:  1.05) msec latency

3         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        29326.45          ---          ---         1.06113         0.84700         5.47100        10.68700     12368.99 
Gets       439896.80      1602.40    438294.40         1.05028         0.83100         5.66300        11.32700     17741.35 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     469223.26      1602.40    438294.40         1.05096         0.83100         5.66300        11.26300     30110.35 
```

## KeyDB benchmark - 1 thread with `server-threads = 2`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 1 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 61%,   0 secs]  1 threads:      122025 ops,  122063 (avg:  122063) o[RUN #1 100%,   1 secs]  0 threads:      200000 ops,  122063 (avg:  124330) ops/sec, 7.57MB/sec (avg: 7.69MB/sec),  0.82 (avg:  0.80) msec latency

1         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets         7770.48          ---          ---         0.81497         0.73500         1.64700         3.34300      3277.33 
Gets       116557.14       148.57    116408.57         0.80363         0.73500         1.50300         3.07100      4596.53 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     124327.62       148.57    116408.57         0.80434         0.73500         1.51100         3.26300      7873.86
```

## KeyDB benchmark - 2 threads with `server-threads = 2`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 2 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 57%,   0 secs]  2 threads:      228292 ops,  228445 (avg:  228445) o[RUN #1 100%,   1 secs]  0 threads:      400000 ops,  228445 (avg:  234666) ops/sec, 14.27MB/sec (avg: 14.61MB/sec),  0.87 (avg:  0.85) msec latency

2         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        14650.89          ---          ---         0.87221         0.79900         1.79900         6.23900      6179.28 
Gets       219763.35       550.29    219213.06         0.85093         0.79900         1.72700         3.71100      8768.67 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     234414.24       550.29    219213.06         0.85226         0.79900         1.73500         4.31900     14947.95
```

## KeyDB benchmark - 3 threads with `server-threads = 2`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 3 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 31%,   1 secs]  3 threads:      185304 ops,  184282 (avg:  184282) o[RUN #1 60%,   2 secs]  3 threads:      360931 ops,  174740 (avg:  179512) o[RUN #1 90%,   2 secs]  2 threads:      541967 ops,  174740 (avg:  186942) o[RUN #1 100%,   3 secs]  0 threads:      600000 ops,  174740 (avg:  195813) ops/sec, 10.95MB/sec (avg: 12.27MB/sec),  1.72 (avg:  1.53) msec latency

3         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        16959.49          ---          ---         1.57837         1.04700        12.22300        25.21500      7152.99 
Gets       254392.40       926.67    253465.73         1.52860         1.02300        12.15900        23.80700     10259.83 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     271351.89       926.67    253465.73         1.53171         1.03100        12.15900        23.80700     17412.82 
```

## KeyDB benchmark - 8 threads with `server-threads = 2`

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 7379 --protocol=redis -t 8 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 15%,   0 secs]  8 threads:      246060 ops,  246178 (avg:  246178) ops[RUN #1 32%,   2 secs]  8 threads:      517616 ops,  271378 (avg:  258785) ops[RUN #1 50%,   3 secs]  8 threads:      796699 ops,  277413 (avg:  265019) ops[RUN #1 67%,   4 secs]  8 threads:     1073383 ops,  276658 (avg:  267924) ops[RUN #1 84%,   4 secs]  6 threads:     1343429 ops,  276658 (avg:  278755) ops[RUN #1 99%,   5 secs]  1 threads:     1589111 ops,  276658 (avg:  304013) ops[RUN #1 100%,   5 secs]  0 threads:     1600000 ops,  276658 (avg:  305825) ops/sec, 17.91MB/sec (avg: 19.83MB/sec),  2.90 (avg:  2.62) msec latency

8         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        22175.40          ---          ---         2.74613         1.68700        13.56700        28.28700      9352.89 
Gets       332631.04      3288.83    329342.20         2.60688         1.67100        12.09500        19.83900     14200.39 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     354806.44      3288.83    329342.20         2.61558         1.67100        12.15900        20.99100     23553.28 
```

## Redis io-threads 1 benchmark - 1 thread

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 1 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 55%,   0 secs]  1 threads:      109583 ops,  109666 (avg:  109666) o[RUN #1 100%,   1 secs]  0 threads:      200000 ops,  109666 (avg:  118476) ops/sec, 6.89MB/sec (avg: 7.42MB/sec),  0.91 (avg:  0.84) msec latency

1         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets         7404.66          ---          ---         0.84763         0.75100         1.51900         3.53500      3123.04 
Gets       111069.97       395.11    110674.86         0.84383         0.75100         1.53500         3.85500      4475.96 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     118474.64       395.11    110674.86         0.84406         0.75100         1.53500         3.82300      7599.00
```

## Redis io-threads 1 benchmark - 2 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 2 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 42%,   0 secs]  2 threads:      166678 ops,  166765 (avg:  166765) o[RUN #1 82%,   1 secs]  2 threads:      326262 ops,  159566 (avg:  163164) o[RUN #1 100%,   2 secs]  0 threads:      400000 ops,  159566 (avg:  164901) ops/sec, 10.00MB/sec (avg: 10.33MB/sec),  1.25 (avg:  1.21) msec latency

2         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        10338.26          ---          ---         1.23153         1.15900         2.22300         4.89500      4360.35 
Gets       155073.83       562.40    154511.43         1.21139         1.14300         2.11100         4.92700      6253.32 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     165412.08       562.40    154511.43         1.21265         1.14300         2.11100         4.92700     10613.67 
````

## Redis io-threads 1 benchmark - 3 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 3 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 20%,   0 secs]  3 threads:      120005 ops,  120074 (avg:  120074) o[RUN #1 41%,   2 secs]  3 threads:      246012 ops,  125617 (avg:  122850) o[RUN #1 60%,   3 secs]  3 threads:      359773 ops,  113748 (avg:  119818) o[RUN #1 81%,   4 secs]  3 threads:      483531 ops,  123742 (avg:  120799) o[RUN #1 100%,   4 secs]  0 threads:      600000 ops,  123742 (avg:  122578) ops/sec, 7.74MB/sec (avg: 7.68MB/sec),  2.42 (avg:  2.45) msec latency

3         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets         6660.16          ---          ---         2.51791         2.49500         5.69500        10.23900      2809.05 
Gets        99902.42       363.91     99538.51         2.44201         2.44700         4.25500        10.55900      4029.14 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     106562.59       363.91     99538.51         2.44675         2.44700         4.47900        10.43100      6838.19 
```

## Redis io-threads 1 benchmark - 8 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 8 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 9%,   1 secs]  8 threads:      144325 ops,  143077 (avg:  143077) ops/[RUN #1 19%,   2 secs]  8 threads:      299317 ops,  153878 (avg:  148474) ops[RUN #1 29%,   3 secs]  8 threads:      464771 ops,  165431 (avg:  154097) ops[RUN #1 39%,   4 secs]  8 threads:      626178 ops,  160306 (avg:  155651) ops[RUN #1 49%,   5 secs]  8 threads:      789115 ops,  162763 (avg:  157068) ops[RUN #1 60%,   6 secs]  8 threads:      957398 ops,  167451 (avg:  158799) ops[RUN #1 70%,   7 secs]  8 threads:     1124484 ops,  167061 (avg:  159974) ops[RUN #1 81%,   8 secs]  8 threads:     1291077 ops,  166540 (avg:  160792) ops[RUN #1 91%,   9 secs]  8 threads:     1453928 ops,  162763 (avg:  161011) ops[RUN #1 100%,   9 secs]  0 threads:     1600000 ops,  162763 (avg:  162238) ops/sec, 10.58MB/sec (avg: 10.52MB/sec),  4.96 (avg:  4.93) msec latency

8         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        10177.75          ---          ---         4.98303         4.57500         8.15900        23.42300      4292.66 
Gets       152666.27      1509.46    151156.81         4.92684         4.51100         8.63900        24.70300      6517.49 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     162844.02      1509.46    151156.81         4.93035         4.51100         8.57500        24.57500     10810.15 
```

## Redis io-threads 2 benchmark - 1 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 1 --distinct-client-seed --hide-histogram --requests=10000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 12%,   0 secs]  1 threads:      124029 ops,  124103 (avg:  124103)[RUN #1 25%,   2 secs]  1 threads:      247139 ops,  123033 (avg:  123568)[RUN #1 36%,   3 secs]  1 threads:      364454 ops,  117302 (avg:  121479)[RUN #1 49%,   4 secs]  1 threads:      492808 ops,  128341 (avg:  123195)[RUN #1 61%,   5 secs]  1 threads:      614439 ops,  121618 (avg:  122879)[RUN #1 74%,   6 secs]  1 threads:      740707 ops,  126235 (avg:  123439)[RUN #1 87%,   7 secs]  1 threads:      867670 ops,  126948 (avg:  123940)[RUN #1 100%,   7 secs]  0 threads:     1000000 ops,  126948 (avg:  126180) ops/sec, 8.08MB/sec (avg: 8.02MB/sec),  0.79 (avg:  0.79) msec latency

1         Threads
100       Connections per thread
10000     Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets         7886.29          ---          ---         0.79585         0.75100         1.28700         3.48700      3326.18 
Gets       118294.40       744.59    117549.80         0.79237         0.75100         1.27900         3.51900      4889.45 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     126180.69       744.59    117549.80         0.79258         0.75100         1.27900         3.50300      8215.63 
```

## Redis io-threads 2 benchmark - 2 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 2 --distinct-client-seed --hide-histogram --requests=10000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 11%,   1 secs]  2 threads:      228085 ops,  227056 (avg:  227056)[RUN #1 24%,   2 secs]  2 threads:      475034 ops,  246862 (avg:  236938)[RUN #1 35%,   3 secs]  2 threads:      703744 ops,  226385 (avg:  233402)[RUN #1 46%,   4 secs]  2 threads:      928753 ops,  224801 (avg:  231259)[RUN #1 56%,   5 secs]  2 threads:     1114366 ops,  184434 (avg:  221876)[RUN #1 67%,   6 secs]  2 threads:     1332922 ops,  218403 (avg:  221299)[RUN #1 78%,   7 secs]  2 threads:     1552007 ops,  218868 (avg:  220953)[RUN #1 89%,   8 secs]  2 threads:     1789472 ops,  237227 (avg:  222983)[RUN #1 100%,   8 secs]  0 threads:     2000000 ops,  237227 (avg:  223898) ops/sec, 15.60MB/sec (avg: 14.71MB/sec),  0.84 (avg:  0.89) msec latency

2         Threads
100       Connections per thread
10000     Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        14104.89          ---          ---         0.89858         0.83100         1.71900        11.51900      5948.98 
Gets       211573.37      2621.48    208951.89         0.89287         0.83100         1.68700        11.26300      9232.37 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     225678.26      2621.48    208951.89         0.89322         0.83100         1.68700        11.26300     15181.35 
```

## Redis io-threads 2 benchmark - 3 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 3 --distinct-client-seed --hide-histogram --requests=10000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 7%,   1 secs]  3 threads:      202942 ops,  202912 (avg:  202912) [RUN #1 15%,   2 secs]  3 threads:      443631 ops,  240663 (avg:  221787)[RUN #1 22%,   3 secs]  3 threads:      664901 ops,  219459 (avg:  221007)[RUN #1 31%,   4 secs]  3 threads:      916792 ops,  250997 (avg:  228508)[RUN #1 38%,   5 secs]  3 threads:     1134556 ops,  216802 (avg:  226164)[RUN #1 45%,   6 secs]  3 threads:     1355264 ops,  220486 (avg:  225220)[RUN #1 52%,   7 secs]  3 threads:     1569024 ops,  212061 (avg:  223332)[RUN #1 58%,   8 secs]  3 threads:     1754232 ops,  183739 (avg:  218364)[RUN #1 65%,   9 secs]  3 threads:     1945297 ops,  191010 (avg:  215335)[RUN #1 72%,  10 secs]  3 threads:     2168521 ops,  223201 (avg:  216119)[RUN #1 80%,  11 secs]  3 threads:     2402698 ops,  234083 (avg:  217748)[RUN #1 87%,  12 secs]  3 threads:     2621809 ops,  218925 (avg:  217846)[RUN #1 95%,  12 secs]  1 threads:     2846717 ops,  218925 (avg:  220574)[RUN #1 99%,  13 secs]  1 threads:     2981558 ops,  218925 (avg:  225204)[RUN #1 100%,  13 secs]  0 threads:     3000000 ops,  218925 (avg:  225905) ops/sec, 14.86MB/sec (avg: 15.32MB/sec),  1.37 (avg:  1.33) msec latency

3         Threads
100       Connections per thread
10000     Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        13244.12          ---          ---         1.33552         1.00700        11.13500        19.58300      5585.92 
Gets       198661.73      3684.20    194977.53         1.32733         1.00700        11.13500        19.45500      9131.06 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     211905.85      3684.20    194977.53         1.32784         1.00700        11.13500        19.45500     14716.98 
```

## Redis io-threads 2 benchmark - 8 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 6379 --protocol=redis -t 8 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 11%,   1 secs]  8 threads:      175164 ops,  174766 (avg:  174766)[RUN #1 23%,   2 secs]  8 threads:      363174 ops,  187963 (avg:  181358)[RUN #1 35%,   3 secs]  8 threads:      557557 ops,  194346 (avg:  185684)[RUN #1 48%,   4 secs]  8 threads:      760091 ops,  202507 (avg:  189887)[RUN #1 60%,   5 secs]  8 threads:      962612 ops,  201756 (avg:  192267)[RUN #1 74%,   6 secs]  8 threads:     1178316 ops,  215665 (avg:  196163)[RUN #1 88%,   7 secs]  8 threads:     1402592 ops,  222233 (avg:  199913)[RUN #1 100%,   7 secs]  0 threads:     1600000 ops,  222233 (avg:  207038) ops/sec, 15.50MB/sec (avg: 14.48MB/sec),  3.58 (avg:  3.86) msec latency

8         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
============================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
----------------------------------------------------------------------------------------------------------------------------
Sets        12750.31          ---          ---         4.04270         3.31100        23.42300        43.77500      5377.68 
Gets       191254.59      4721.95    186532.64         3.85142         3.27900        15.23100        44.54300      9234.77 
Waits           0.00          ---          ---             ---             ---             ---             ---          --- 
Totals     204004.90      4721.95    186532.64         3.86338         3.27900        15.99900        44.54300     14612.45 
```

# KeyDB Cluster Setup

* [Create KeyDB Servers](#create-keydb-servers)
* [Create KeyDB Cluster](#create-keydb-cluster)

Based on modifed version of the [official script](https://docs.keydb.dev/docs/cluster-tutorial/#creating-a-keydb-cluster-using-the-create-cluster-script).

```
./centminmod-keydb-create-cluster.sh

Usage: ./centminmod-keydb-create-cluster.sh [start|create|stop|watch|tail|clean|call]

start       -- Launch Redis Cluster instances.
create [-f] -- Create a cluster using keydb-cli --cluster create.
stop        -- Stop Redis Cluster instances.
watch       -- Show CLUSTER NODES output (first 30 lines) of first node.
tail <id>   -- Run tail -f of instance at base port + ID.
tailall     -- Run tail -f for all the log files at once.
clean       -- Remove all instances data, logs, configs.
clean-logs  -- Remove just instances logs.
call <cmd>  -- Call a command (up to 7 arguments) on all nodes.
```

## Create KeyDB Servers

```
./centminmod-keydb-create-cluster.sh start

Starting 30001
Starting 30002
Starting 30003
Starting 30004
Starting 30005
Starting 30006
```

```
ls -lAh /etc/keydb/cluster
total 24K
-rw-r--r-- 1 root root 114 Dec 14 08:15 nodes-30001.conf
-rw-r--r-- 1 root root 114 Dec 14 08:15 nodes-30002.conf
-rw-r--r-- 1 root root 114 Dec 14 08:15 nodes-30003.conf
-rw-r--r-- 1 root root 114 Dec 14 08:15 nodes-30004.conf
-rw-r--r-- 1 root root 114 Dec 14 08:15 nodes-30005.conf
-rw-r--r-- 1 root root 114 Dec 14 08:15 nodes-30006.conf
```

```
ls -lAh /var/lib/keydb-cluster
total 0
-rw-r--r-- 1 root root 0 Dec 14 08:15 appendonly-30001.aof
-rw-r--r-- 1 root root 0 Dec 14 08:15 appendonly-30002.aof
-rw-r--r-- 1 root root 0 Dec 14 08:15 appendonly-30003.aof
-rw-r--r-- 1 root root 0 Dec 14 08:15 appendonly-30004.aof
-rw-r--r-- 1 root root 0 Dec 14 08:15 appendonly-30005.aof
-rw-r--r-- 1 root root 0 Dec 14 08:15 appendonly-30006.aof
```

```
ls -laH /var/log/keydb-cluster
total 28
drwxr-xr-x   2 keydb keydb  108 Dec 14 08:15 .
drwxr-xr-x. 16 root  root  4096 Dec 14 08:10 ..
-rw-r--r--   1 root  root   718 Dec 14 08:15 30001.log
-rw-r--r--   1 root  root   718 Dec 14 08:15 30002.log
-rw-r--r--   1 root  root   718 Dec 14 08:15 30003.log
-rw-r--r--   1 root  root   718 Dec 14 08:15 30004.log
-rw-r--r--   1 root  root   718 Dec 14 08:15 30005.log
-rw-r--r--   1 root  root   718 Dec 14 08:15 30006.log
```

```
./centminmod-keydb-create-cluster.sh tailall

==> /var/log/keydb-cluster/30001.log <==
81185:81184:C 14 Dec 2023 08:15:48.143 # oO0OoO0OoO0Oo KeyDB is starting oO0OoO0OoO0Oo
81185:81184:C 14 Dec 2023 08:15:48.143 # KeyDB version=6.3.4, bits=64, commit=7e7e5e57, modified=0, pid=81185, just started
81185:81184:C 14 Dec 2023 08:15:48.143 # Configuration loaded
81185:81184:M 14 Dec 2023 08:15:48.144 * monotonic clock: POSIX clock_gettime
81185:81184:M 14 Dec 2023 08:15:48.145 * No cluster configuration found, I'm 2c411c29b604c34a7e65f928adb2677cf5aa7ad8
81185:81184:M 14 Dec 2023 08:15:48.146 * Running mode=cluster, port=30001.
81185:81184:M 14 Dec 2023 08:15:48.146 # Server initialized
81185:81195:M 14 Dec 2023 08:15:48.147 * Thread 0 alive.
81185:81196:M 14 Dec 2023 08:15:48.147 * Thread 1 alive.

==> /var/log/keydb-cluster/30002.log <==
81199:81186:C 14 Dec 2023 08:15:48.151 # oO0OoO0OoO0Oo KeyDB is starting oO0OoO0OoO0Oo
81199:81186:C 14 Dec 2023 08:15:48.151 # KeyDB version=6.3.4, bits=64, commit=7e7e5e57, modified=0, pid=81199, just started
81199:81186:C 14 Dec 2023 08:15:48.151 # Configuration loaded
81199:81186:M 14 Dec 2023 08:15:48.153 * monotonic clock: POSIX clock_gettime
81199:81186:M 14 Dec 2023 08:15:48.153 * No cluster configuration found, I'm a9f6c77f2b51b7926bf180a29dbb45bc54426a95
81199:81186:M 14 Dec 2023 08:15:48.154 * Running mode=cluster, port=30002.
81199:81186:M 14 Dec 2023 08:15:48.154 # Server initialized
81199:81209:M 14 Dec 2023 08:15:48.155 * Thread 0 alive.
81199:81210:M 14 Dec 2023 08:15:48.155 * Thread 1 alive.

==> /var/log/keydb-cluster/30003.log <==
81213:81200:C 14 Dec 2023 08:15:48.158 # oO0OoO0OoO0Oo KeyDB is starting oO0OoO0OoO0Oo
81213:81200:C 14 Dec 2023 08:15:48.158 # KeyDB version=6.3.4, bits=64, commit=7e7e5e57, modified=0, pid=81213, just started
81213:81200:C 14 Dec 2023 08:15:48.158 # Configuration loaded
81213:81200:M 14 Dec 2023 08:15:48.159 * monotonic clock: POSIX clock_gettime
81213:81200:M 14 Dec 2023 08:15:48.160 * No cluster configuration found, I'm a834ef1507c8ae55c97d1528612de2ec313c5c3f
81213:81200:M 14 Dec 2023 08:15:48.161 * Running mode=cluster, port=30003.
81213:81200:M 14 Dec 2023 08:15:48.161 # Server initialized
81213:81222:M 14 Dec 2023 08:15:48.161 * Thread 0 alive.
81213:81223:M 14 Dec 2023 08:15:48.162 * Thread 1 alive.

==> /var/log/keydb-cluster/30004.log <==
81227:81214:C 14 Dec 2023 08:15:48.166 # oO0OoO0OoO0Oo KeyDB is starting oO0OoO0OoO0Oo
81227:81214:C 14 Dec 2023 08:15:48.166 # KeyDB version=6.3.4, bits=64, commit=7e7e5e57, modified=0, pid=81227, just started
81227:81214:C 14 Dec 2023 08:15:48.166 # Configuration loaded
81227:81214:M 14 Dec 2023 08:15:48.167 * monotonic clock: POSIX clock_gettime
81227:81214:M 14 Dec 2023 08:15:48.168 * No cluster configuration found, I'm 7be028710efd8db002543fb62c38ef681c736342
81227:81214:M 14 Dec 2023 08:15:48.169 * Running mode=cluster, port=30004.
81227:81214:M 14 Dec 2023 08:15:48.169 # Server initialized
81227:81236:M 14 Dec 2023 08:15:48.169 * Thread 0 alive.
81227:81238:M 14 Dec 2023 08:15:48.170 * Thread 1 alive.

==> /var/log/keydb-cluster/30005.log <==
81241:81228:C 14 Dec 2023 08:15:48.174 # oO0OoO0OoO0Oo KeyDB is starting oO0OoO0OoO0Oo
81241:81228:C 14 Dec 2023 08:15:48.174 # KeyDB version=6.3.4, bits=64, commit=7e7e5e57, modified=0, pid=81241, just started
81241:81228:C 14 Dec 2023 08:15:48.174 # Configuration loaded
81241:81228:M 14 Dec 2023 08:15:48.175 * monotonic clock: POSIX clock_gettime
81241:81228:M 14 Dec 2023 08:15:48.176 * No cluster configuration found, I'm 603cee91acbc03417388956c0acbca2f7f1e5520
81241:81228:M 14 Dec 2023 08:15:48.177 * Running mode=cluster, port=30005.
81241:81228:M 14 Dec 2023 08:15:48.177 # Server initialized
81241:81251:M 14 Dec 2023 08:15:48.178 * Thread 0 alive.
81241:81252:M 14 Dec 2023 08:15:48.178 * Thread 1 alive.

==> /var/log/keydb-cluster/30006.log <==
81255:81242:C 14 Dec 2023 08:15:48.182 # oO0OoO0OoO0Oo KeyDB is starting oO0OoO0OoO0Oo
81255:81242:C 14 Dec 2023 08:15:48.182 # KeyDB version=6.3.4, bits=64, commit=7e7e5e57, modified=0, pid=81255, just started
81255:81242:C 14 Dec 2023 08:15:48.182 # Configuration loaded
81255:81242:M 14 Dec 2023 08:15:48.183 * monotonic clock: POSIX clock_gettime
81255:81242:M 14 Dec 2023 08:15:48.183 * No cluster configuration found, I'm 81907d013ad96ec3911d43cff46157744fe54ee4
81255:81242:M 14 Dec 2023 08:15:48.185 * Running mode=cluster, port=30006.
81255:81242:M 14 Dec 2023 08:15:48.185 # Server initialized
81255:81264:M 14 Dec 2023 08:15:48.185 * Thread 0 alive.
81255:81265:M 14 Dec 2023 08:15:48.185 * Thread 1 alive.
```

```
keydb-cli -p 30001 info
# Server
redis_version:6.3.4
redis_git_sha1:7e7e5e57
redis_git_dirty:0
redis_build_id:8e0b8f8680ec0369
redis_mode:cluster
os:Linux 4.18.0-477.27.2.el8_8.x86_64 x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:11.2.1
process_id:81185
process_supervised:no
run_id:830224eb5152080144900cb1ef4776ea211ba740
tcp_port:30001
server_time_usec:1702542023479624
uptime_in_seconds:275
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:8043207
executable:/usr/local/bin/keydb-server
config_file:
availability_zone:
features:cluster_mget

# Clients
connected_clients:1
cluster_connections:0
maxclients:10000
client_recent_max_input_buffer:0
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
current_client_thread:1
thread_0_clients:0
thread_1_clients:1

# Memory
used_memory:2728208
used_memory_human:2.60M
used_memory_rss:8499200
used_memory_rss_human:8.11M
used_memory_peak:2728208
used_memory_peak_human:2.60M
used_memory_peak_perc:100.07%
used_memory_overhead:2663264
used_memory_startup:2663256
used_memory_dataset:64944
used_memory_dataset_perc:99.99%
allocator_allocated:3328832
allocator_active:3784704
allocator_resident:6819840
total_system_memory:3998314496
total_system_memory_human:3.72G
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.14
allocator_frag_bytes:455872
allocator_rss_ratio:1.80
allocator_rss_bytes:3035136
rss_overhead_ratio:1.25
rss_overhead_bytes:1679360
mem_fragmentation_ratio:3.19
mem_fragmentation_bytes:5834808
mem_not_counted_for_evict:4
mem_replication_backlog:0
mem_clients_slaves:0
mem_clients_normal:0
mem_aof_buffer:8
mem_allocator:jemalloc-5.2.1
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0
storage_provider:none
available_system_memory:unavailable

# Persistence
loading:0
current_cow_size:0
current_cow_size_age:0
current_fork_perc:0.00
current_save_keys_processed:0
current_save_keys_total:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1702541748
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:-1
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:0
aof_enabled:1
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0
aof_current_size:0
aof_base_size:0
aof_pending_rewrite:0
aof_buffer_length:0
aof_rewrite_buffer_length:0
aof_pending_bio_fsync:0
aof_delayed_fsync:0

# Stats
total_connections_received:1
total_commands_processed:0
instantaneous_ops_per_sec:0
total_net_input_bytes:14
total_net_output_bytes:0
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:2
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:0
total_forks:0
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_error_replies:0
dump_payload_sanitizations:0
total_reads_processed:1
total_writes_processed:0
instantaneous_lock_contention:1
avg_lock_contention:0.000000
storage_provider_read_hits:0
storage_provider_read_misses:0

# Replication
role:master
connected_slaves:0
master_failover_state:no-failover
master_replid:a035a5b7cb8b28aa35f55ade67cd53555701a108
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:0
second_repl_offset:-1
repl_backlog_active:0
repl_backlog_size:1048576
repl_backlog_first_byte_offset:0
repl_backlog_histlen:0

# CPU
used_cpu_sys:0.306334
used_cpu_user:0.463858
used_cpu_sys_children:0.000000
used_cpu_user_children:0.000000
server_threads:2
long_lock_waits:0
used_cpu_sys_main_thread:0.058076
used_cpu_user_main_thread:0.073361

# Modules

# Errorstats

# Cluster
cluster_enabled:1

# Keyspace

# KeyDB
mvcc_depth:0
```

## Create KeyDB Cluster

```
./centminmod-keydb-create-cluster.sh create

>>> Performing hash slots allocation on 6 nodes...
Master[0] -> Slots 0 - 5460
Master[1] -> Slots 5461 - 10922
Master[2] -> Slots 10923 - 16383
Adding replica 127.0.0.1:30005 to 127.0.0.1:30001
Adding replica 127.0.0.1:30006 to 127.0.0.1:30002
Adding replica 127.0.0.1:30004 to 127.0.0.1:30003
>>> Trying to optimize slaves allocation for anti-affinity
[WARNING] Some slaves are in the same host as their master
M: 2c411c29b604c34a7e65f928adb2677cf5aa7ad8 127.0.0.1:30001
   slots:[0-5460] (5461 slots) master
M: a9f6c77f2b51b7926bf180a29dbb45bc54426a95 127.0.0.1:30002
   slots:[5461-10922] (5462 slots) master
M: a834ef1507c8ae55c97d1528612de2ec313c5c3f 127.0.0.1:30003
   slots:[10923-16383] (5461 slots) master
S: 7be028710efd8db002543fb62c38ef681c736342 127.0.0.1:30004
   replicates a834ef1507c8ae55c97d1528612de2ec313c5c3f
S: 603cee91acbc03417388956c0acbca2f7f1e5520 127.0.0.1:30005
   replicates 2c411c29b604c34a7e65f928adb2677cf5aa7ad8
S: 81907d013ad96ec3911d43cff46157744fe54ee4 127.0.0.1:30006
   replicates a9f6c77f2b51b7926bf180a29dbb45bc54426a95
Can I set the above configuration? (type 'yes' to accept): yes

>>> Nodes configuration updated
>>> Assign a different config epoch to each node
>>> Sending CLUSTER MEET messages to join the cluster
Waiting for the cluster to join
.
>>> Performing Cluster Check (using node 127.0.0.1:30001)
M: 2c411c29b604c34a7e65f928adb2677cf5aa7ad8 127.0.0.1:30001
   slots:[0-5460] (5461 slots) master
   1 additional replica(s)
M: a834ef1507c8ae55c97d1528612de2ec313c5c3f 127.0.0.1:30003
   slots:[10923-16383] (5461 slots) master
   1 additional replica(s)
M: a9f6c77f2b51b7926bf180a29dbb45bc54426a95 127.0.0.1:30002
   slots:[5461-10922] (5462 slots) master
   1 additional replica(s)
S: 603cee91acbc03417388956c0acbca2f7f1e5520 127.0.0.1:30005
   slots: (0 slots) slave
   replicates 2c411c29b604c34a7e65f928adb2677cf5aa7ad8
S: 7be028710efd8db002543fb62c38ef681c736342 127.0.0.1:30004
   slots: (0 slots) slave
   replicates a834ef1507c8ae55c97d1528612de2ec313c5c3f
S: 81907d013ad96ec3911d43cff46157744fe54ee4 127.0.0.1:30006
   slots: (0 slots) slave
   replicates a9f6c77f2b51b7926bf180a29dbb45bc54426a95
[OK] All nodes agree about slots configuration.
>>> Check for open slots...
>>> Check slots coverage...
[OK] All 16384 slots covered.
```

```
keydb-cli -p 30001 info
# Server
redis_version:6.3.4
redis_git_sha1:7e7e5e57
redis_git_dirty:0
redis_build_id:8e0b8f8680ec0369
redis_mode:cluster
os:Linux 4.18.0-477.27.2.el8_8.x86_64 x86_64
arch_bits:64
multiplexing_api:epoll
atomicvar_api:atomic-builtin
gcc_version:11.2.1
process_id:81185
process_supervised:no
run_id:830224eb5152080144900cb1ef4776ea211ba740
tcp_port:30001
server_time_usec:1702542266451594
uptime_in_seconds:518
uptime_in_days:0
hz:10
configured_hz:10
lru_clock:8043450
executable:/usr/local/bin/keydb-server
config_file:
availability_zone:
features:cluster_mget

# Clients
connected_clients:1
cluster_connections:10
maxclients:10000
client_recent_max_input_buffer:32
client_recent_max_output_buffer:0
blocked_clients:0
tracking_clients:0
clients_in_timeout_table:0
current_client_thread:0
thread_0_clients:2
thread_1_clients:0

# Memory
used_memory:3874232
used_memory_human:3.69M
used_memory_rss:9060352
used_memory_rss_human:8.64M
used_memory_peak:3913472
used_memory_peak_human:3.73M
used_memory_peak_perc:99.00%
used_memory_overhead:3732352
used_memory_startup:2663256
used_memory_dataset:141880
used_memory_dataset_perc:11.72%
allocator_allocated:4624368
allocator_active:5419008
allocator_resident:8507392
total_system_memory:3998314496
total_system_memory_human:3.72G
used_memory_lua:37888
used_memory_lua_human:37.00K
used_memory_scripts:0
used_memory_scripts_human:0B
number_of_cached_scripts:0
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
allocator_frag_ratio:1.17
allocator_frag_bytes:794640
allocator_rss_ratio:1.57
allocator_rss_bytes:3088384
rss_overhead_ratio:1.06
rss_overhead_bytes:552960
mem_fragmentation_ratio:2.38
mem_fragmentation_bytes:5249936
mem_not_counted_for_evict:4
mem_replication_backlog:1048576
mem_clients_slaves:20512
mem_clients_normal:0
mem_aof_buffer:8
mem_allocator:jemalloc-5.2.1
active_defrag_running:0
lazyfree_pending_objects:0
lazyfreed_objects:0
storage_provider:none
available_system_memory:unavailable

# Persistence
loading:0
current_cow_size:0
current_cow_size_age:0
current_fork_perc:0.00
current_save_keys_processed:0
current_save_keys_total:0
rdb_changes_since_last_save:0
rdb_bgsave_in_progress:0
rdb_last_save_time:1702542113
rdb_last_bgsave_status:ok
rdb_last_bgsave_time_sec:0
rdb_current_bgsave_time_sec:-1
rdb_last_cow_size:647168
aof_enabled:1
aof_rewrite_in_progress:0
aof_rewrite_scheduled:0
aof_last_rewrite_time_sec:-1
aof_current_rewrite_time_sec:-1
aof_last_bgrewrite_status:ok
aof_last_write_status:ok
aof_last_cow_size:0
module_fork_in_progress:0
module_fork_last_cow_size:0
aof_current_size:0
aof_base_size:0
aof_pending_rewrite:0
aof_buffer_length:0
aof_rewrite_buffer_length:0
aof_pending_bio_fsync:0
aof_delayed_fsync:0

# Stats
total_connections_received:4
total_commands_processed:169
instantaneous_ops_per_sec:1
total_net_input_bytes:59526
total_net_output_bytes:21420
instantaneous_input_kbps:0.04
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:1
sync_partial_ok:0
sync_partial_err:1
expired_keys:0
expired_stale_perc:0.00
expired_time_cap_reached_count:0
expire_cycle_cpu_milliseconds:4
evicted_keys:0
keyspace_hits:0
keyspace_misses:0
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:786
total_forks:1
migrate_cached_sockets:0
slave_expires_tracked_keys:0
active_defrag_hits:0
active_defrag_misses:0
active_defrag_key_hits:0
active_defrag_key_misses:0
tracking_total_keys:0
tracking_total_items:0
tracking_total_prefixes:0
unexpected_error_replies:0
total_error_replies:0
dump_payload_sanitizations:0
total_reads_processed:174
total_writes_processed:31
instantaneous_lock_contention:1
avg_lock_contention:0.125000
storage_provider_read_hits:0
storage_provider_read_misses:0

# Replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=30005,state=online,offset=233,lag=1
master_failover_state:no-failover
master_replid:1d789d444625817325c702a6357f858b085bef6a
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:233
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:233

# CPU
used_cpu_sys:0.654101
used_cpu_user:0.918530
used_cpu_sys_children:0.000000
used_cpu_user_children:0.002029
server_threads:2
long_lock_waits:0
used_cpu_sys_main_thread:0.356825
used_cpu_user_main_thread:0.563670

# Modules

# Errorstats

# Cluster
cluster_enabled:1

# Keyspace

# KeyDB
mvcc_depth:0
```

```
keydb-cli -p 30001 cluster nodes

a834ef1507c8ae55c97d1528612de2ec313c5c3f 127.0.0.1:30003@40003 master - 0 1702542686133 3 connected 10923-16383
a9f6c77f2b51b7926bf180a29dbb45bc54426a95 127.0.0.1:30002@40002 master - 0 1702542686434 2 connected 5461-10922
603cee91acbc03417388956c0acbca2f7f1e5520 127.0.0.1:30005@40005 slave 2c411c29b604c34a7e65f928adb2677cf5aa7ad8 0 1702542686133 1 connected
7be028710efd8db002543fb62c38ef681c736342 127.0.0.1:30004@40004 slave a834ef1507c8ae55c97d1528612de2ec313c5c3f 0 1702542686133 3 connected
2c411c29b604c34a7e65f928adb2677cf5aa7ad8 127.0.0.1:30001@40001 myself,master - 0 1702542685000 1 connected 0-5460
81907d013ad96ec3911d43cff46157744fe54ee4 127.0.0.1:30006@40006 slave a9f6c77f2b51b7926bf180a29dbb45bc54426a95 0 1702542686434 2 connected
```

Replica related config parameters

```
keydb-cli -p 30001 CONFIG GET "*replica*"
 1) "lua-replicate-commands"
 2) "yes"
 3) "cluster-replica-no-failover"
 4) "no"
 5) "replica-lazy-flush"
 6) "no"
 7) "replica-serve-stale-data"
 8) "yes"
 9) "replica-read-only"
10) "yes"
11) "replica-ignore-maxmemory"
12) "no"
13) "cluster-allow-replica-migration"
14) "yes"
15) "replica-announced"
16) "yes"
17) "replica-announce-ip"
18) ""
19) "cluster-replica-validity-factor"
20) "10"
21) "replica-priority"
22) "100"
23) "replica-announce-port"
24) "0"
25) "repl-ping-replica-period"
26) "10"
27) "min-replicas-to-write"
28) "0"
29) "min-replicas-max-lag"
30) "10"
31) "replica-quorum"
32) "-1"
33) "replica-weighting-factor"
34) "2"
35) "tls-replication"
36) "no"
37) "replicaof"
38) ""
39) "active-replica"
40) "no"
```

## KeyDB Cluster benchmarks

### KeyDB cluster benchmarks - 1 thread

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 30001 --protocol=redis -t 1 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 --cluster-mode

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 47%,   0 secs]  1 threads:       94092 ops,   95788 (avg:   95788) o[RUN #1 98%,   1 secs]  1 threads:      195217 ops,  101120 (avg:   98478) o[RUN #1 100%,   2 secs]  0 threads:      200000 ops,  101120 (avg:   98317) ops/sec, 6.25MB/sec (avg: 6.08MB/sec),  2.93 (avg:  3.00) msec latency

1         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
======================================================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    MOVED/sec      ASK/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
------------------------------------------------------------------------------------------------------------------------------------------------------
Sets         6144.77          ---          ---         0.00         0.00         3.04864         2.75100         5.56700        16.76700      2591.66 
Gets        92171.56       117.49     92054.07         0.00         0.00         2.99752         2.75100         4.89500         8.06300      3634.86 
Waits           0.00          ---          ---          ---          ---             ---             ---             ---             ---          --- 
Totals      98316.33       117.49     92054.07         0.00         0.00         3.00071         2.75100         4.89500         8.15900      6226.53
```

### KeyDB cluster benchmarks - 2 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 30001 --protocol=redis -t 2 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 --cluster-mode

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 50%,   0 secs]  2 threads:      199260 ops,  204559 (avg:  204559) o[RUN #1 95%,   1 secs]  2 threads:      378952 ops,  179701 (avg:  191967) o[RUN #1 100%,   2 secs]  0 threads:      400000 ops,  179701 (avg:  192928) ops/sec, 11.17MB/sec (avg: 12.01MB/sec),  3.13 (avg:  2.94) msec latency

2         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
======================================================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    MOVED/sec      ASK/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
------------------------------------------------------------------------------------------------------------------------------------------------------
Sets        15613.65          ---          ---         0.00         0.00         2.97576         2.35100        12.92700        29.69500      6585.34 
Gets       234204.76       586.45    233618.31         0.00         0.00         2.93380         2.33500        12.60700        30.07900      9344.89 
Waits           0.00          ---          ---          ---          ---             ---             ---             ---             ---          --- 
Totals     249818.41       586.45    233618.31         0.00         0.00         2.93642         2.33500        12.60700        30.07900     15930.23
```

### KeyDB cluster benchmarks - 3 threads

```
memtier_benchmark -s 127.0.0.1 --ratio=1:15 -p 30001 --protocol=redis -t 3 --distinct-client-seed --hide-histogram --requests=2000 --clients=100 --pipeline=1 --data-size=384 --cluster-mode

Writing results to stdout
[RUN #1] Preparing benchmark client...
[RUN #1] Launching threads now...
[RUN #1 29%,   0 secs]  3 threads:      175345 ops,  181056 (avg:  181056) o[RUN #1 64%,   1 secs]  3 threads:      385501 ops,  208996 (avg:  195289) o[RUN #1 93%,   2 secs]  1 threads:      556200 ops,  208996 (avg:  197411) o[RUN #1 100%,   2 secs]  0 threads:      600000 ops,  208996 (avg:  203420) ops/sec, 13.10MB/sec (avg: 12.75MB/sec),  4.05 (avg:  3.93) msec latency

3         Threads
100       Connections per thread
2000      Requests per client


ALL STATS
======================================================================================================================================================
Type         Ops/sec     Hits/sec   Misses/sec    MOVED/sec      ASK/sec    Avg. Latency     p50 Latency     p99 Latency   p99.9 Latency       KB/sec 
------------------------------------------------------------------------------------------------------------------------------------------------------
Sets        14466.26          ---          ---         0.00         0.00         3.94049         2.41500        18.81500        34.55900      6101.42 
Gets       216993.96       790.44    216203.53         0.00         0.00         3.93215         2.39900        18.68700        34.81500      8751.52 
Waits           0.00          ---          ---          ---          ---             ---             ---             ---             ---          --- 
Totals     231460.23       790.44    216203.53         0.00         0.00         3.93267         2.39900        18.68700        34.81500     14852.95
```

### KeyDB Cluster Diagnostics

```
keydb-diagnostic-tool -h 127.0.0.1 -p 30001 2>&1 | tee keydb-dignostic1.log

Server has 2 threads.
Starting...
1 threads, 50 total clients. CPU Usage Self: 95.5% (95.5% per thread), Serve2 threads, 100 total clients. CPU Usage Self: 186.6% (93.3% per thread), Ser3 threads, 150 total clients. CPU Usage Self: 259.4% (86.5% per thread), Ser4 threads, 200 total clients. CPU Usage Self: 259.8% (64.9% per thread), Ser5 threads, 250 total clients. CPU Usage Self: 306.4% (61.3% per thread), Ser6 threads, 300 total clients. CPU Usage Self: 365.8% (61.0% per thread), Server: 1.1% (0.5% per thread)
Server CPU load appears to have stagnated with increasing clients.
Server does not appear to be at full load. Check network for throughput.
Done.
```