require 'spec_helper'
require './lib/eatl/pipeline'

describe Eatl::Pipeline do
  it 'performs each action on an object' do
    pipeline = described_class.new([
      ->(str) { str.upcase },
      ->(str) { str[1..3] },
    ])

    expect(pipeline.call("hello")).to eq("ELL")
  end
end
