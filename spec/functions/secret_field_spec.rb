# frozen_string_literal: true

require 'spec_helper'

describe 'vault::secret_field' do
  context 'get default secret key' do
    it { is_expected.to run.with_params('namevar').and_return('secret') }
  end
  context 'get specific secret key' do
    it { is_expected.to run.with_params('namevar', 'path').and_return('test') }
  end
end
