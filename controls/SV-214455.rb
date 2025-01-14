control 'SV-214455' do
  title 'Mappings to unused and vulnerable scripts on the IIS 8.5 website must be removed.'
  desc 'IIS 8.5 will either allow or deny script execution based on file extension. The ability to control script execution is controlled through two features with IIS 8.5, “Request Filtering” and "Handler Mappings".

For "Request Filtering", the ISSO must document and approve all allowable file extensions the website allows (white list) and denies (black list) by the website. The white list and black list will be compared to the "Request Filtering" in IIS 8. "Request Filtering" at the site level take precedence over "Request Filtering" at the server level.'
  desc 'check', 'Note: If the server being reviewed is hosting SharePoint, this is Not Applicable.

For Request Filtering, the ISSO must document and approve all allowable scripts the website allows (white list) and denies (black list). The white list and black list will be compared to the Request Filtering in IIS 8.5. 

Open the IIS 8.5 Manager.

Click the site name under review.

Double-click "Request Filtering".

If any script file extensions from the black list are enabled, this is a finding.'
  desc 'fix', 'Open the IIS 8.5 Manager.

Click the site name under review.

Double-click "Request Filtering".

Deny any script file extensions listed on the black list.

Select "Apply" from the "Actions" pane.'
  impact 0.5
  ref 'DPMS Target Microsoft IIS 8.5 Site'
  tag gtitle: 'SRG-APP-000141-WSR-000082'
  tag gid: 'V-214455'
  tag rid: 'SV-214455r903087_rule'
  tag stig_id: 'IISW-SI-000215'
  tag fix_id: 'F-15662r903086_fix'
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']
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

  describe 'Manually review the Handler Mappings' do
    skip 'Manually review site Handler Mappings configuration; If any script file
    extensions from the black list are enabled, this is a finding."'
  end

  get_names = json(command: 'ConvertTo-Json @(Get-Website | select -expand name)').params
  if get_names.empty?
    impact 0.0
    desc 'There are no IIS sites configured hence the control is Not-Applicable'

    describe 'No sites where found to be reviewed' do
      skip 'No sites where found to be reviewed'
    end
  end
end
