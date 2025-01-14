control 'SV-214452' do
  title 'The IIS 8.5 website must produce log records containing sufficient information to establish the identity of any user/subject or process associated with an event.'
  desc 'Web server logging capability is critical for accurate forensic analysis. Without sufficient and accurate information, a correct replay of the events cannot be determined.

Determining user accounts, processes running on behalf of the user, and running process identifiers also enable a better understanding of the overall event. User tool identification is also helpful to determine if events are related to overall user access or specific client tools.

Log record content that may be necessary to satisfy the requirement of this control includes: time stamps, source and destination addresses, user/process identifiers, event descriptions, success/fail indications, file names involved, and access control or flow control rules invoked.'
  desc 'check', 'Follow the procedures below for each site hosted on the IIS 8.5 web server:

Access the IIS 8.5 web server IIS 8.5 Manager.

Under "IIS", double-click the "Logging" icon.

Verify the "Format:" under "Log File" is configured to "W3C".

Select the "Fields" button.

Under "Standard Fields", verify "User Agent", "User Name" and "Referrer" are selected.

Under "Custom Fields", verify the following fields have been configured: 

Request Header >> Authorization

Response Header >> Content-Type

If any of the above fields are not selected, this is a finding.'
  desc 'fix', 'Follow the procedures below for each site hosted on the IIS 8.5 web server:

Access the IIS 8.5 web server IIS 8.5 Manager.

Select the website being reviewed.

Under "IIS", double-click the "Logging" icon.

Configure the "Format:" under "Log File" to "W3C".

Select the "Fields" button.

Under "Standard Fields", select "User Agent", "User Name" and "Referrer".

Under "Custom Fields", select the following fields:

Request Header >> Authorization

Response Header >> Content-Type

Click "OK".

Select "Apply" from the "Actions" pane.'
  impact 0.5
  ref 'DPMS Target Microsoft IIS 8.5 Site'
  tag gtitle: 'SRG-APP-000100-WSR-000064'
  tag gid: 'V-214452'
  tag rid: 'SV-214452r879568_rule'
  tag stig_id: 'IISW-SI-000210'
  tag fix_id: 'F-15659r310561_fix'
  tag cci: ['CCI-001487']
  tag nist: ['AU-3', 'AU-3 f']
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

  site_names = json(command: 'ConvertTo-Json @(Get-Website | select -expand name)').params

  site_names.each do |site_name|
    iis_logging_configuration = json(command: %(Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'System.Applicationhost/Sites/site[@name="#{site_name}"]/logfile'  -Name * | ConvertTo-Json))

    describe "IIS Logging configuration for Site :'#{site_name}'" do
      subject { iis_logging_configuration }
      its('logFormat') { should cmp 'W3C' }
      its('logExtFileFlags') { should include 'UserName' }
      its('logExtFileFlags') { should include 'UserAgent' }
      its('logExtFileFlags') { should include 'Referer' }
    end
  end

  site_names.each do |site_name|
    custom_field_configuration = command("Get-WebConfiguration -filter \"system.applicationHost/sites/site[@name=\'#{site_name}\']/logFile/customFields/*\"").stdout.strip
    describe "IIS Custom Fields Logging configuration for Site :'#{site_name}'" do
      subject { custom_field_configuration }
      it { should match /sourceName\s+:\s+User-Agent\s+sourceType\s+:\s+RequestHeader/ }
      it { should match /sourceName\s+:\s+Authorization\s+sourceType\s+:\s+RequestHeader/ }
      it { should match /sourceName\s+:\s+Content-Type\s+sourceType\s+:\s+RequestHeader/ }
      it { should match /sourceName\s+:\s+HTTP_USER_AGENT\s+sourceType\s+:\s+ServerVariable/ }
    end
  end

  if site_names.empty?
    impact 0.0
    desc 'There are no IIS sites configured hence the control is Not-Applicable'

    describe 'No sites where found to be reviewed' do
      skip 'No sites where found to be reviewed'
    end
  end
end
