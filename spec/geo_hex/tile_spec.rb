require 'spec_helper'

describe GeoHex::Tile do

  subject do
    described_class.new(5700, 5717, 7)
  end

  it             { should_not be_meridian_180 }
  its(:unit)     { should be_instance_of(GeoHex::Unit) }
  its(:level)    { should == 7 }
  its(:easting)  { should be_within(1).of(-17306) }
  its(:northing) { should be_within(1).of(6710328) }
  its(:to_ll)    { should be_instance_of(GeoHex::LL) }

  describe "if on meridian 180" do
    subject { described_class.new(7, -2, 0) }

    it { should be_meridian_180 }
    its(:x) { should == -2 }
    its(:y) { should == 7 }
  end

  describe "lan/lon" do
    subject { described_class.new(5700, 5717, 7).to_ll }

    its(:lat) { should be_within(0.0001).of(51.5006) }
    its(:lon) { should be_within(0.0001).of(-0.1554) }
  end

  describe "normalize" do

    subject { described_class.normalize(-17306, 6710328, 7) }

    its(:level) { should == 7 }
    its(:x)     { should == 5700 }
    its(:y)     { should == 5717 }
    its(:easting)  { should be_within(1).of(-17306) }
    its(:northing) { should be_within(1).of(6710328) }

  end

end