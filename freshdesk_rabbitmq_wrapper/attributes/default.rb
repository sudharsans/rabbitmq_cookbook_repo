# see https://github.com/opscode-cookbooks/rabbitmq/blob/master/attributes/default.rb for more attributes.

#networking
default['rabbitmq']['web_console_ssl_port'] = "8080"  
default['rabbitmq']['tcp_listener_custom']= "9999"

# clustering
default['rabbitmq']['erlang_cookie'] = 'MYNAMEISSUDHARSANSIVSANKARAN'

#get all instances from layers rabbit
instances = node[:opsworks][:layers][:rabbitmq][:instances]
rabbit_nodes = instances.map{ |name, attrs| "rabbit@#{name}" }

default['rabbitmq']['cluster_disk_nodes'] = rabbit_nodes
default['rabbitmq']['cluster_partition_handling'] = 'ignore'

default['rabbitmq']['user'] = 'freshdesk'
default['rabbitmq']['password'] = 'fresh@desk'
