require 'spec_helper'

describe GeoHex::LL do

  subject do
    described_class.new(51.2, 0.0)
  end

  it "should normalize longitude" do
    described_class.new(51.0, -182).lon.should == 178
    described_class.new(51.0, 182).lon.should == -178
  end

  it 'should convert to zone' do
    subject.to_zone(7).should be_instance_of(GeoHex::Zone)
    subject.to_zone(7).x.should == 5663
    subject.to_zone(7).y.should == 5663
  end

end
