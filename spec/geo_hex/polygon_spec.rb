require 'spec_helper'

describe GeoHex::Polygon do

  subject do
    described_class.new(-17306, 6710328, 339.33)
  end

  def projection(*args)
    GeoHex::PP.new(*args)
  end

  its(:north_east_point) { should be_a(GeoHex::PP) }
  its(:north_east_point) { should == projection(-16966.67, 6710505.672772524) }
  it "should alias north_east_point to ne" do
    subject.north_east_point.should eq(subject.ne)
  end

  its(:east_point) { should be_a(GeoHex::PP) }
  its(:east_point) { should == projection(-16627.34, 6710328) }
  it "should alias east_point to e" do 
    subject.east_point.should eq(subject.e)
  end

  its(:south_east_point) { should be_a(GeoHex::PP) }
  its(:south_east_point) { should == projection(-16966.67, 6710150.327227476 ) }
  it "should alias south_east_point to se" do 
    subject.south_east_point.should eq(subject.se)
  end

  its(:south_west_point) { should be_a(GeoHex::PP) }
  its(:south_west_point) { should == projection(-17645.33, 6710150.327227476) }
  it "should alias south_west_point to sw" do 
    subject.south_west_point.should eq(subject.sw)
  end

  its(:west_point) { should be_a(GeoHex::PP) }
  its(:west_point) { should == projection(-17984.66, 6710328) }
  it "should alias west_point to w" do 
    subject.west_point.should eq(subject.w)
  end

  its(:north_west_point) { should be_a(GeoHex::PP) }
  its(:north_west_point) { should == projection(-17645.33, 6710505.672772524) }
  it "should alias north_west_point to w" do 
    subject.north_west_point.should eq(subject.nw)
  end

  describe "points" do
    it "should include all 6 coordinates from NE round to NW" do
      subject.points.should == [
        subject.north_east_point,
        subject.east_point,
        subject.south_east_point,
        subject.south_west_point,
        subject.west_point,
        subject.north_west_point
      ]
    end
  end
end
