require 'spec_helper'
require './lib/eatr/transformation/add_date_id'

describe Eatr::Transformation::AddDateId do
  it "sets a destination field from a source Date object" do
    row = Struct.new(:created_at, :created_at_date_id).new(Date.new(2016,8,1))

    transform = described_class.new(
      'source' => 'created_at',
      'destination' => 'created_at_date_id'
    )
    expect {
      transform.call([row])
    }.to change(row, :created_at_date_id).from(nil).to(20160801)
  end

  it "does nothing if the source is blank" do
    row = Struct.new(:created_at, :created_at_date_id).new

    transform = described_class.new(
      'source' => 'created_at',
      'destination' => 'created_at_date_id'
    )
    expect {
      transform.call([row])
    }.to_not change(row, :created_at_date_id).from(nil)
  end
end

