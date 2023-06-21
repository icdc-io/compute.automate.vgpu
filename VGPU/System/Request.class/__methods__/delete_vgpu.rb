require 'ovirtsdk4'
require 'rest-client'

$evm.log(:info, "======DELETING VGPU======")
vm = $evm.root['vm']
vm_uuid = vm.uid_ems
ems = vm.ext_management_system
endpoint = ems.endpoints.select { |endpoint| endpoint if endpoint.role == "default" }[0]
ovirt_url = "https://#{endpoint.hostname + endpoint.path}"
username = ems.authentication_userid
password = ems.authentication_password

mdev_response = RestClient::Request.execute(
  method: :get, 
  url: "#{ovirt_url}/vms/#{vm_uuid}/mediateddevices",
  :user => username,
  :password => password,
  :verify_ssl => false)  

vm_mediated_device = Hash.from_xml(mdev_response)["vm_mediated_devices"]["vm_mediated_device"]

if vm_mediated_device.is_a? Hash
  RestClient::Request.execute(method: :delete, url: "#{ovirt_url}/vms/#{vm_uuid}/mediateddevices/#{vm_mediated_device["id"]}",
    :user => username,
    :password => password,
    :verify_ssl => false)
elsif vm_mediated_device.is_a? Array
  vm_mediated_device.collect { |d| d["id"] }.each do |mdev_uuid|
    RestClient::Request.execute(method: :delete, url: "#{ovirt_url}/vms/#{vm_uuid}/mediateddevices/#{mdev_uuid}",
      :user => username,
      :password => password,
      :verify_ssl => false)
  end
end
$evm.instantiate("/System/Request/RestartVM")
