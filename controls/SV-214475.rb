control 'SV-214475' do
  title 'The IIS 8.5 websites connectionTimeout setting must be explicitly configured to disconnect an idle session.'
  desc 'Leaving sessions open indefinitely is a major security risk. An attacker can easily use an already authenticated session to access the hosted application as the previously authenticated user. By closing sessions after a set period of inactivity, the web server can make certain that those sessions that are not closed through the user logging out of an application are eventually closed.

Acceptable values are 5 minutes for high-value applications, 10 minutes for medium-value applications, and 20 minutes for low-value applications.'
  desc 'check', 'Follow the procedures below for each site hosted on the IIS 8.5 web server:

Open the IIS 8.5 Manager.

Click the site name.

Select "Configuration Editor" under the "Management" section.

From the "Section:" drop-down list at the top of the configuration editor, locate "system.web/sessionState".

Verify the "timeout" is set to "00:20:00 or less”, using the lowest value possible depending upon the application.
Acceptable values are 5 minutes for high-value applications, 10 minutes for medium-value applications, and 20 minutes for low-value applications.

If "timeout" is not set to "00:20:00 or less”, this is a finding.'
  desc 'fix', 'Follow the procedures below for each site hosted on the IIS 8.5 web server:

Open the IIS 8.5 Manager.

Click the site name.

Select "Configuration Editor" under the "Management" section.

From the "Section:" drop-down list at the top of the configuration editor, locate "system.web/sessionState". 

Set the "timeout" to "00:20:00 or less”, using the lowest value possible depending upon the application.
Acceptable values are 5 minutes for high-value applications, 10 minutes for medium-value applications, and 20 minutes for low-value applications.

In the "Actions" pane, click "Apply".'
  impact 0.5
  ref 'DPMS Target Microsoft IIS 8.5 Site'
  tag gtitle: 'SRG-APP-000295-WSR-000134'
  tag gid: 'V-214475'
  tag rid: 'SV-214475r879673_rule'
  tag stig_id: 'IISW-SI-000236'
  tag fix_id: 'F-15682r310630_fix'
  tag cci: ['CCI-002361']
  tag nist: ['AC-12']
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

  get_names = command("Get-Website | select name | findstr /v 'name ---'").stdout.strip.split("\r\n")
  get_connectionTimeout = command('Get-WebConfigurationProperty -pspath "IIS:\Sites\*" -Filter system.web/sessionState -name * | select -expand timeout | select -expand TotalMinutes').stdout.strip.split("\r\n")

  get_connectionTimeout.zip(get_names).each do |connectionTimeout, names|
    n = names.strip

    describe "The IIS site: #{n} websites connection timeout" do
      subject { connectionTimeout }
      it { should cmp <= 20 }
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
