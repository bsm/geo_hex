# frozen_string_literal: true

require 'spec_helper'

describe GeoHex::LL do
  subject do
    described_class.new(51.2, -0.1)
  end

  its(:easting)  { should be_within(1).of(-11_132) }
  its(:northing) { should be_within(1).of(6_656_748) }
  its(:to_pp)    { should be_instance_of(GeoHex::PP) }

  it 'should normalize longitude' do
    expect(described_class.new(51.0, -182).lon).to eq(178)
    expect(described_class.new(51.0, 182).lon).to eq(-178)
  end

  it 'should convert to zone' do
    expect(subject.to_zone(7)).to be_instance_of(GeoHex::Zone)
    expect(subject.to_zone(7).x).to eq(5657)
    expect(subject.to_zone(7).y).to eq(5668)
  end

  it 'should calculate distance' do
    expect(subject.distance_to(described_class.new(40.69, -74.04))).to be_within(1).of(5_586_704)
  end
end
