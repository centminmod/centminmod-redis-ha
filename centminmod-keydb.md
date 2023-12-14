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

`memtier_benchmark` comparing Redis vs KeyDB for 1, 2, 3 threads on 4 CPU core KVM VPS running AlmaLinux 8 with Centmin Mod 130.00beta01 LEMP stack.

| Database | Threads | Sets (ops/sec) | Gets (ops/sec) | Totals (ops/sec) | 
|-|-|-|-|-|
| KeyDB | 1 | 7770.48 | 116557.14 | 124327.62 |
| KeyDB | 2 | 14650.89 | 219763.35 | 234414.24 |  
| KeyDB | 3 | 16959.49 | 254392.40 | 271351.89 |
| Redis | 1 | 7404.66 | 111069.97 | 118474.64 |
| Redis | 2 | 10338.26 | 155073.83 | 165412.08 |
| Redis | 3 | 6660.16 | 99902.42 | 106562.59 |

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