# frozen_string_literal: true

describe file('/etc/secrets/data_from_function') do
  it { is_expected.to exist }
  its('content') { should eq 'secrettoken' }
end

describe file('/etc/secrets/test/test1') do
  it { is_expected.to exist }
  its('owner') { is_expected.to eq 'kitchen' }
  its('group') { is_expected.to eq 'kitchen' }
  its('mode') { should cmp '0644' }
  its('content') { should eq 'secretfile' }
end

describe file('/etc/secrets/ssl/test2.crt') do
  it { is_expected.to exist }
  its('owner') { is_expected.to eq 'kitchen' }
  its('group') { is_expected.to eq 'kitchen' }
  its('mode') { should cmp '0644' }
  its('content') { should eq 'secretcert' }
end

describe file('/etc/secrets/ssl/test2.key') do
  it { is_expected.to exist }
  its('owner') { is_expected.to eq 'kitchen' }
  its('group') { is_expected.to eq 'kitchen' }
  its('mode') { should cmp '0400' }
  its('content') { should eq 'secretkey' }
end
