# frozen_string_literal: true

require 'spec_helper'

describe 'vault::parents' do
  {
    '/a/b/c/d/': ['/a', '/a/b', '/a/b/c'],
    'a/b/c/d/':  ['a', 'a/b', 'a/b/c'],
    '/a/b/c/d':  ['/a', '/a/b', '/a/b/c'],
    'a/b/c/d':   ['a', 'a/b', 'a/b/c'],
    '/a': [],
    'a': [],
    '': [],
  }.each do |test, answer|
    context test do
      it { is_expected.to run.with_params(test.to_s).and_return(answer) }
    end
  end
end
