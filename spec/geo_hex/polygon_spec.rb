require 'spec_helper'

describe GeoHex::Polygon do

  subject do
    described_class.new(-17306, 6710328, 339.33)
  end

  def projection(*args)
    GeoHex::PP.new(*args)
  end

  its(:north_east) { should be_a(GeoHex::PP) }
  its(:north_east) { should == projection(-16966.67, 6710505.672772524) }
  it "should alias north_east to ne" do
    subject.north_east.should eq(subject.ne)
  end

  its(:east) { should be_a(GeoHex::PP) }
  its(:east) { should == projection(-16627.34, 6710328) }
  it "should alias east to e" do
    subject.east.should eq(subject.e)
  end

  its(:south_east) { should be_a(GeoHex::PP) }
  its(:south_east) { should == projection(-16966.67, 6710150.327227476 ) }
  it "should alias south_east to se" do
    subject.south_east.should eq(subject.se)
  end

  its(:south_west) { should be_a(GeoHex::PP) }
  its(:south_west) { should == projection(-17645.33, 6710150.327227476) }
  it "should alias south_west to sw" do
    subject.south_west.should eq(subject.sw)
  end

  its(:west) { should be_a(GeoHex::PP) }
  its(:west) { should == projection(-17984.66, 6710328) }
  it "should alias west to w" do
    subject.west.should eq(subject.w)
  end

  its(:north_west) { should be_a(GeoHex::PP) }
  its(:north_west) { should == projection(-17645.33, 6710505.672772524) }
  it "should alias north_west to w" do
    subject.north_west.should eq(subject.nw)
  end

  describe "points" do
    it "should include all 6 coordinates from NE round to NW" do
      subject.points.should == [
        subject.north_east,
        subject.east,
        subject.south_east,
        subject.south_west,
        subject.west,
        subject.north_west
      ]
    end
  end
end
