require 'spec_helper'

describe GeoHex::Polygon do

  let(:pg) { GeoHex.decode("QE0166383").polygon }
  subject  { pg }

  describe "centroid" do
    subject { pg.centroid.to_ll }

    its(:lat) { should be_within(10**-6).of(51.500613) }
    its(:lon) { should be_within(10**-6).of(-0.155464) }
    it "should alias to c" do
      pg.c.should eq(pg.centroid)
    end
  end

  describe "east" do
    subject { pg.east.to_ll }

    its(:lat) { should be_within(10**-6).of(51.500613) }
    its(:lon) { should be_within(10**-6).of(-0.149367) }
    it "should alias to e" do
      pg.e.should eq(pg.east)
    end
  end

  describe "west" do
    subject { pg.west.to_ll }

    its(:lat) { should be_within(10**-6).of(51.500613) }
    its(:lon) { should be_within(10**-6).of(-0.161560) }
    it "should alias to w" do
      pg.w.should eq(pg.west)
    end
  end

  describe "north east" do
    subject { pg.north_east.to_ll }

    its(:lat) { should be_within(10**-6).of(51.503899) }
    its(:lon) { should be_within(10**-6).of(-0.152415) }
    it "should alias to ne" do
      pg.ne.should eq(pg.north_east)
    end
  end

  describe "north west" do
    subject { pg.north_west.to_ll }

    its(:lat) { should be_within(10**-6).of(51.503899) }
    its(:lon) { should be_within(10**-6).of(-0.158512) }
    it "should alias to nw" do
      pg.nw.should eq(pg.north_west)
    end
  end

  describe "south east" do
    subject { pg.south_east.to_ll }

    its(:lat) { should be_within(10**-6).of(51.497326) }
    its(:lon) { should be_within(10**-6).of(-0.152415) }
    it "should alias to se" do
      pg.se.should eq(pg.south_east)
    end
  end

  describe "south west" do
    subject { pg.south_west.to_ll }

    its(:lat) { should be_within(10**-6).of(51.497326) }
    its(:lon) { should be_within(10**-6).of(-0.158512) }
    it "should alias to sw" do
      pg.sw.should eq(pg.south_west)
    end
  end

  its(:points) do
    should == [pg.north_east, pg.east, pg.south_east, pg.south_west, pg.west, pg.north_west]
  end

end
