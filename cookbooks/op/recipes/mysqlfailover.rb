package 'mysql-utilities' do
    action :install
    end
execute 'start_mysqlfailover_daemon' do
    command "/usr/bin/mysqlfailover --master=root:abc123@10.211.55.9:3306 --discover-slaves-login=root:abc123 --force --log=/var/log/mysql/failover.log >/dev/null &"
end
