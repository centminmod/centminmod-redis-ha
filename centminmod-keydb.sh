#!/bin/bash
# ==========================================================================
# Centmin Mod EL8+ system keydb server install
# ==========================================================================

keydb_install() {
  yum install -y libuuid-devel which libatomic tcltls libzstd rpm-build
  
  if [[ -f /opt/rh/gcc-toolset-11/root/usr/bin/gcc && -f /opt/rh/gcc-toolset-11/root/usr/bin/g++ ]]; then
    source /opt/rh/gcc-toolset-11/enable
  elif [[ -f /opt/rh/gcc-toolset-10/root/usr/bin/gcc && -f /opt/rh/gcc-toolset-10/root/usr/bin/g++ ]]; then
    source /opt/rh/gcc-toolset-10/enable
  fi
  
  # install KeyDB via source compile to allow KeyDB to run
  # beside existing Redis YUM packages
  mkdir -p /svr-setup
  cd /svr-setup
  rm -rf KeyDB
  git clone https://github.com/Snapchat/KeyDB
  cd KeyDB
  git fetch --all
  git checkout RELEASE_6_3_4
  git pull
  make distclean
  time make -j$(nproc) BUILD_TLS=yes USE_SYSTEMD=yes MALLOC=jemalloc
  #time make test
  time make install
  \cp -af ./src/keydb-diagnostic-tool /usr/local/bin/keydb-diagnostic-tool
 
  # add keydb linux user
  getent group keydb &> /dev/null || groupadd -r keydb &> /dev/null
  getent passwd keydb &> /dev/null || useradd -r -g keydb -d /var/lib/keydb -s /sbin/nologin -c 'KeyDB Database Server' keydb &> /dev/null
  
  # setup /etc/keydb directory
  KEYDB_DIR=/etc/keydb
  mkdir -p $KEYDB_DIR
  \cp -af keydb.conf $KEYDB_DIR
  
  # setup directories and permissions
  mkdir -p /var/run/keydb /var/log/keydb /var/lib/keydb
  chown -R keydb:keydb /var/run/keydb /var/log/keydb /etc/keydb /var/lib/keydb
  chmod 755 /var/run/keydb
  echo "d      /var/run/keydb/         0755 keydb keydb" > /etc/tmpfiles.d/keydb.conf
  
  # adjust default keydb server to run on TCP port 7379 to not conflict
  # with redis default 6379 port and setup keydb.conf defaults
  sed -i 's|^port 6379|port 7379|' ${KEYDB_DIR}/keydb.conf
  sed -i 's|^tcp-backlog 511|tcp-backlog 65535|' ${KEYDB_DIR}/keydb.conf
  sed -i 's|dir ./|dir /var/lib/keydb|' ${KEYDB_DIR}/keydb.conf
  sed -i 's|^pidfile /var/run/keydb_6379.pid|pidfile /var/run/keydb/keydb_7379.pid|' ${KEYDB_DIR}/keydb.conf
  sed -i 's|^logfile ""|logfile /var/log/keydb/keydb.log|' ${KEYDB_DIR}/keydb.conf
  # if [ "$(nproc)" -ge '4' ]; then
  #   sed -i 's|^# server-thread-affinity|server-thread-affinity|' ${KEYDB_DIR}/keydb.conf
  # fi
  cat ${KEYDB_DIR}/keydb.conf | egrep '^pid|^port|^log|^dir|^tcp-backlog|^server-threads|server-thread'
  
  # setup logrotate and systemd service files and dependencies
  \cp -af ./pkg/rpm/keydb_build/keydb_rpm/etc/logrotate.d/keydb /etc/logrotate.d/keydb
  \cp -af ./pkg/rpm/keydb_build/keydb_rpm/usr/lib/systemd/system/keydb.service /usr/lib/systemd/system/keydb.service
  \cp -af ./pkg/rpm/keydb_build/keydb_rpm/usr/lib/systemd/system/keydb-sentinel.service /usr/lib/systemd/system/keydb-sentinel.service
  \cp -af ./pkg/rpm/keydb_build/keydb_rpm/usr/libexec/keydb-shutdown /usr/libexec/keydb-shutdown
  chown -R keydb:keydb /usr/libexec/keydb-shutdown
  
  # adjust systemd service files
  sed -i 's|Type=forking|Type=notify|' /usr/lib/systemd/system/keydb.service
  sed -i 's|\/usr\/bin\/keydb-|\/usr\/local\/bin\/keydb-|g' /usr/lib/systemd/system/keydb.service
  sed -i 's|\/usr\/bin\/keydb-|\/usr\/local\/bin\/keydb-|g' /usr/lib/systemd/system/keydb-sentinel.service
  sed -i 's|\/usr\/local\/bin\/keydb-server \/etc\/keydb\/keydb.conf|\/usr\/local\/bin\/keydb-server \/etc\/keydb\/keydb.conf --daemonize no --supervised systemd|' /usr/lib/systemd/system/keydb.service
  
  # modify keydb service limits
  mkdir -p /etc/systemd/system/keydb.service.d /etc/systemd/system/keydb-sentinel.service.d
  \cp -af ./pkg/rpm/keydb_build/keydb_rpm/etc/systemd/system/keydb.service.d/limit.conf /etc/systemd/system/keydb.service.d/limit.conf
  \cp -af ./pkg/rpm/keydb_build/keydb_rpm/etc/systemd/system/keydb-sentinel.service.d/limit.conf /etc/systemd/system/keydb-sentinel.service.d/limit.conf
  sed -i 's|10240|65535|' /etc/systemd/system/keydb.service.d/limit.conf
  sed -i 's|10240|65535|' /etc/systemd/system/keydb-sentinel.service.d/limit.conf
  
  # only enable keydb-server
  echo "systemctl daemon-reload"
  systemctl daemon-reload
  echo "systemctl enable keydb"
  systemctl enable keydb
  echo "systemctl start keydb"
  systemctl start keydb
  echo "systemctl status keydb --no-pager -l"
  systemctl status keydb --no-pager -l

  echo
  echo "keydb server installed"
  echo
  prlimit -p $(pidof keydb-server)
  echo
  keydb-server -v
  echo
}

help() {
  echo
  echo "Usage:"
  echo
  echo "$0 {install|upgrade}"
}

case "$1" in
  install )
    keydb_install
    ;;
  upgrade )
    keydb_upgrade
    ;;
  * )
    help
    ;;
esac
