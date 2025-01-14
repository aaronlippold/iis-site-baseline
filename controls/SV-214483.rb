control 'SV-214483' do
  title 'The IIS 8.5 website must maintain the confidentiality and integrity of information during preparation for transmission and during reception.'
  desc 'Information can be either unintentionally or maliciously disclosed or modified during preparation for transmission, including, for example, during aggregation, at protocol transformation points, and during packing/unpacking. These unauthorized disclosures or modifications compromise the confidentiality or integrity of the information.

An example of this would be an SMTP queue. This queue may be added to a web server through an SMTP module to enhance error reporting or to allow developers to add SMTP functionality to their applications. 

Any modules used by the web server that queue data before transmission must maintain the confidentiality and integrity of the information before the data is transmitted.

Information can be either unintentionally or maliciously disclosed or modified during reception, including, for example, during aggregation, at protocol transformation points, and during packing/unpacking. These unauthorized disclosures or modifications compromise the confidentiality or integrity of the information. 

Protecting the confidentiality and integrity of received information requires that application servers take measures to employ approved cryptography in order to protect the information during transmission over the network. This is usually achieved through the use of Transport Layer Security (TLS), SSL VPN, or IPsec tunnel. 

The web server must utilize approved encryption when receiving transmitted data.

Also satisfies: SRG-APP-000442-WSR-000182'
  desc 'check', 'Note: If the server being reviewed is a public IIS 8.5 web server, this is Not Applicable.
Note: If the server being reviewed is hosting SharePoint, this is Not Applicable.
Note: If SSL is installed on load balancer/proxy server through which traffic is routed to the IIS 8.5 server, and the IIS 8.5 server receives traffic from the load balancer/proxy server, the SSL requirement must be met on the load balancer/proxy server.

Follow the procedures below for each site hosted on the IIS 8.5 web server:

Open the IIS 8.5 Manager.
Double-click the "SSL Settings" icon under the "IIS" section.
Verify "Require SSL" is checked.
Verify "Client Certificates Required" is selected.
Click the site under review.
Select "Configuration Editor" under the "Management" section.
From the "Section:" drop-down list at the top of the configuration editor, locate “system.webServer/security/access”.
The value for "sslFlags" should be “ssl128”.

If the "Require SSL" is not selected, this is a finding.
If the "Client Certificates Required" is not selected, this is a finding.
If the "sslFlags" is not set to "ssl128", this is a finding.'
  desc 'fix', 'Follow the procedures below for web server and each site under review:

Open the IIS 8.5 Manager.
Double-click the "SSL Settings" icon under the "IIS" section.
Verify "Require SSL" is checked.
Verify "Client Certificates Required" is selected.
Click the site under review.
Select "Configuration Editor" under the "Management" section.
From the "Section:" drop-down list at the top of the configuration editor, locate “system.webServer/security/access”.
The value for "sslFlags" should be “ssl128”.'
  impact 0.5
  ref 'DPMS Target Microsoft IIS 8.5 Site'
  tag gtitle: 'SRG-APP-000441-WSR-000181'
  tag gid: 'V-214483'
  tag rid: 'SV-214483r903103_rule'
  tag stig_id: 'IISW-SI-000249'
  tag fix_id: 'F-15690r903102_fix'
  tag cci: ['CCI-002420', 'CCI-002422']
  tag nist: ['SC-8 (2)']
  tag 'false_negatives'
  tag 'false_positives'
  tag 'documentable'
  tag 'mitigations'
  tag 'severity_override_guidance'
  tag 'potential_impacts'
  tag 'third_party_tools'
  tag 'mitigation_controls'
  tag 'responsibility'
  tag 'ia_controls'
  tag 'check'
  tag 'fix'

  get_names = json(command: 'ConvertTo-Json @(Get-Website | select -expand name)').params

  get_names.each do |site_name|
    iis_configuration = json(command: "Get-WebConfigurationProperty -Filter system.webServer/security/access 'IIS:\\Sites\\#{site_name}'  -Name * | ConvertTo-Json")

    describe "IIS sessionState for site :'#{site_name}'" do
      subject { iis_configuration }
      its('sslFlags') { should include 'Ssl' }
      its('sslFlags') { should include 'SslRequireCert' }
      its('sslFlags') { should include 'Ssl128' }
    end
  end

  if get_names.empty?
    impact 0.0
    desc 'There are no IIS sites configured hence the control is Not-Applicable'

    describe 'No sites where found to be reviewed' do
      skip 'No sites where found to be reviewed'
    end
  end
end
