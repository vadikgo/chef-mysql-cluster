execute 'up_cluster_interface' do
    command "ifconfig eth0:0 #{node['op']['mysql_cl_ip']} netmask 255.255.255.0 up"
end
