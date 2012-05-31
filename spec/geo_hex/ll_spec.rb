require 'spec_helper'

describe GeoHex::LL do

  subject do
    described_class.new(51.2, -0.1)
  end

  its(:easting)  { should be_within(1).of(-11132) }
  its(:northing) { should be_within(1).of(6656748) }

  it "should normalize longitude" do
    described_class.new(51.0, -182).lon.should == 178
    described_class.new(51.0, 182).lon.should == -178
  end

  it 'should convert to zone' do
    subject.to_zone(7).should be_instance_of(GeoHex::Zone)
    subject.to_zone(7).x.should == 5657
    subject.to_zone(7).y.should == 5668
  end

end
