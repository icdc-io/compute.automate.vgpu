require 'ovirtsdk4'
require 'rest-client'

$evm.log(:info, "======ADDING VGPU======")
vm = $evm.root['vm']
vm_uuid = vm.uid_ems
ems = vm.ext_management_system
endpoint = ems.endpoints.select { |endpoint| endpoint if endpoint.role == "default" }[0]
ovirt_url = "https://#{endpoint.hostname + endpoint.path}"
username = ems.authentication_userid
password = ems.authentication_password
request_body = {
  "spec_params": {
    "property": [
      {
        "name": "nodisplay",
        "value": true
      },
      {
        "name": "mdevType",
        "value": $evm.root['dialog_mdevType']
      }
    ]
  }
}.to_json

$evm.log(:info, "DEBUG add_vgpu \n #{ovirt_url} :: #{vm_uuid} :: \n #{request_body}")
RestClient::Request.execute(method: :post, url: "#{ovirt_url}/vms/#{vm_uuid}/mediateddevices",
    					   :user => username,
						   :password => password,
  						   :headers => {
                             :content_type => 'application/json'
                           },
  					   	   :payload => request_body,
   						   :verify_ssl => false)
$evm.instantiate("/System/Request/RestartVM")
