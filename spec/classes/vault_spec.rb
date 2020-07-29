# frozen_string_literal: true

require 'spec_helper'

describe 'vault' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { 'secrets' => ['namevar'], 'ssl' => ['namevar'] } }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
