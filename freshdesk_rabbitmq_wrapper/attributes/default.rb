default['rabbitmq']['web_console_port'] = "8080"  
default['rabbitmq']['tcp_listener_custom']= "9999"
default['rabbitmq']['erlang_cookie'] = 'FRRKIUIZPNNCHNITHOSB'
instances = node[:opsworks][:layers][:rabbitmq][:instances]
rabbit_nodes = instances.map{ |name, attrs| "rabbit@#{name}" }
default['rabbitmq']['cluster_disk_nodes'] = rabbit_nodes
default['rabbitmq']['cluster_partition_handling'] = 'ignore'
