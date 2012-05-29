require 'spec_helper'

describe GeoHex::XY do

  subject do
    described_class.new(1234, 6789)
  end

  let :normalized do
    described_class.normalize(1234.5, 6789.1)
  end

  it 'should convert to lat/lon' do
    subject.to_ll.should be_instance_of(GeoHex::LL)
    subject.to_ll.lat.should be_within(0.001).of(0.06)
    subject.to_ll.lon.should be_within(0.001).of(0.011)
  end

  it 'should normalize position' do
    normalized.x.should == 1234
    normalized.y.should == 6789
  end

  it 'should invert X/Y' do
    subject.invert!
    subject.x.should == 6789
    subject.y.should == 1234
  end

end

describe GeoHex::LL do

  subject do
    described_class.new(0.06098, 0.01109)
  end

  it 'should convert to X/Z' do
    subject.to_xy.should be_instance_of(GeoHex::XY)
    subject.to_xy.x.should be_within(1).of(1234)
    subject.to_xy.y.should be_within(1).of(6789)
  end

end
