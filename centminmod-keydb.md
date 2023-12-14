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

# Benchmarks

`memtier_benchmark` comparing Redis 7.2.3 vs KeyDB 6.3.4 for 1, 2, 3 threads on 4 CPU core KVM VPS running AlmaLinux 8 with Centmin Mod 130.00beta01 LEMP stack.

| Database | Threads | Sets (ops/sec) | Gets (ops/sec) | Totals (ops/sec) | 
|-|-|-|-|-|
| KeyDB 6.3.4 | 1 | 7770.48 | 116557.14 | 124327.62 |
| KeyDB 6.3.4 | 2 | 14650.89 | 219763.35 | 234414.24 |  
| KeyDB 6.3.4 | 3 | 16959.49 | 254392.40 | 271351.89 |
| Redis 7.2.3 | 1 | 7404.66 | 111069.97 | 118474.64 |
| Redis 7.2.3 | 2 | 10338.26 | 155073.83 | 165412.08 |
| Redis 7.2.3 | 3 | 6660.16 | 99902.42 | 106562.59 |

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

## KeyDB benchmark - 1 thread

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

## KeyDB benchmark - 2 threads

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

## KeyDB benchmark - 3 threads

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

## Redis benchmark - 1 thread

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

## Redis benchmark - 2 threads

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

## Redis benchmark - 3 threads

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

## KeyDB benchmarks

### KeyDB benchmarks - 1 thread

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

### KeyDB benchmarks - 2 threads

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

### KeyDB benchmarks - 3 threads

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