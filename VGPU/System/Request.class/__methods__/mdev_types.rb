require 'ovirtsdk4'
require 'rest-client'

$evm.log(:info, "======GETTING MDEVTYPES======")
vm = $evm.root['vm']
ems = vm.ext_management_system
$evm.log(:info, "Debug vm #{vm.inspect} ")
devices = {}
ems.connect.system_service.hosts_service.list.collect(&:id).each do |host_id|
  ems.connect.system_service.hosts_service.host_service(host_id).devices_service.list.each do |device|
    devices.merge!(host_id => device.id) if device.driver == 'nvidia'
  end
end
$evm.object['default_value'] = ''
exit MIQ_OK if devices.empty?
endpoint = ems.endpoints.select { |endpoint| endpoint if endpoint.role == "default" }[0]
ovirt_url = "https://#{endpoint.hostname + endpoint.path}"
username = ems.authentication_userid
password = ems.authentication_password
list = {}
devices.each do |host_id, device_id|
  host_device = RestClient::Request.execute(method: :get, url: "#{ovirt_url}/hosts/#{host_id}/devices/#{device_id}",
  										   :user => username,
										   :password => password,
										   :verify_ssl => false)
  mdev_types = Hash.from_xml(host_device).dig('host_device', 'm_dev_types', 'm_dev_type')
  next unless mdev_types
  
  mdev_types.each do |mdev_type|
    name = mdev_type['name']
    readable_name = "#{mdev_type['human_readable_name']} (#{Hash.from_xml(host_device).dig('host_device', 'product', 'name')})"
    list.merge!(name => readable_name) if mdev_type['available_instances'].to_i > 0
  end
end
$evm.object['values'] = list
$evm.object["data_type"] = "string"
