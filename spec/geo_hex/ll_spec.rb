require 'spec_helper'

describe GeoHex::LL do

  subject do
    described_class.new(51.2, 0.0)
  end

  it "should normalize longitude" do
    described_class.new(51.0, -182).lon.should == 178
    described_class.new(51.0, 182).lon.should == -178
  end

  it 'should convert to tile' do
    subject.to_tile(7).should be_instance_of(GeoHex::Tile)
    subject.to_tile(7).x.should == 5663
    subject.to_tile(7).y.should == 5663
  end

end
