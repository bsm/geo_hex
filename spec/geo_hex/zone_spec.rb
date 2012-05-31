require 'spec_helper'

describe GeoHex::Zone do

  subject do
    described_class.new(5700, 5717, 7)
  end

  it             { should_not be_meridian_180 }
  its(:unit)     { should be_instance_of(GeoHex::Unit) }
  its(:level)    { should == 7 }
  its(:easting)  { should be_within(1).of(-17306) }
  its(:northing) { should be_within(1).of(6710328) }
  its(:code)     { should == "QE0166383" }
  its(:lat)      { should be_within(0.0001).of(51.5006) }
  its(:lon)      { should be_within(0.0001).of(-0.1554) }

  it 'should find neighbours' do
    subject.neighbours(1).should have(6).items
    subject.neighbours(2).should have(18).items
    subject.neighbours(3).should have(36).items
  end

  describe "if on meridian 180" do
    subject { described_class.new(7, -2, 0) }

    it { should be_meridian_180 }
    its(:x) { should == -2 }
    its(:y) { should == 7 }
  end

  describe "normalize" do
    subject { described_class.normalize(-17306, 6710328, 7) }

    its(:level) { should == 7 }
    its(:x)     { should == 5700 }
    its(:y)     { should == 5717 }
    its(:easting)  { should be_within(1).of(-17306) }
    its(:northing) { should be_within(1).of(6710328) }
  end

  it "should be comparable" do
    subject.should == subject
    subject.should == subject.to_s
    subject.should eql(subject)
  end

end
