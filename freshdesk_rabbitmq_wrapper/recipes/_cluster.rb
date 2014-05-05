
#take first node in the rabbitmq layer as the master node
def cluster_cmd()
  require 'socket'
  instances = node[:opsworks][:layers][:rabbitmq][:instances]
  hostname= Socket.gethostname
  master_node=instances[0]

  if master_node == hostname
      Chef::Log.info "This is a considered as a master node, Existing cluster setup"
      exit 0
    else
      puts "rabbitmqctl join_cluster #{master_node}"
    end
end

# Need to reset for clustering
execute 'cluster' do
  command 'rabbitmqctl stop_app &&  #{cluster_cmd} && rabbitmqctl start_app'
  action :run 
end
