# frozen_string_literal: true

require 'spec_helper'

describe 'vault::secret' do
  context 'get secret' do
    it { is_expected.to run.with_params('secret').and_return('a' => 'a', 'b' => 'b') }
  end
end
