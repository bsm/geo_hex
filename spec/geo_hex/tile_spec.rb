require 'spec_helper'

describe GeoHex::Tile do

  subject do
    described_class.new(5700, 5717, 7)
  end

  its(:unit)     { should be_instance_of(GeoHex::Unit) }
  its(:level)    { should == 7 }
  its(:easting)  { should be_within(1).of(-17306) }
  its(:northing) { should be_within(1).of(6710328) }
  its(:to_ll)    { should be_instance_of(GeoHex::LL) }


  it 'should be invertable' do
    subject.invert!
    subject.x.should == 5717
    subject.y.should == 5700
  end

  describe "lan/lon" do
    subject { described_class.new(5700, 5717, 7).to_ll }

    its(:lat) { should be_within(0.0001).of(51.5006) }
    its(:lon) { should be_within(0.0001).of(-0.1554) }
  end

  describe "normalize" do

    subject do
      described_class.normalize(-17306, 6710328, 7)
    end

    its(:level) { should == 7 }
    its(:x)     { should == 5700 }
    its(:y)     { should == 5717 }
    its(:easting)  { should be_within(1).of(-17306) }
    its(:northing) { should be_within(1).of(6710328) }

  end

end
