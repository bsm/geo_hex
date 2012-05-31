require 'spec_helper'

describe GeoHex::Polygon do

  let(:pg) { GeoHex.decode("QE0166383").polygon }
  subject  { pg }

  describe "east" do
    subject { pg.east.to_ll }

    its(:lat) { should be_within(0.001).of(51.500) }
    its(:lon) { should be_within(0.001).of(-0.149) }
    it "should alias to e" do
      pg.e.should eq(pg.east)
    end
  end

  describe "west" do
    subject { pg.west.to_ll }

    its(:lat) { should be_within(0.001).of(51.500) }
    its(:lon) { should be_within(0.001).of(-0.161) }
    it "should alias to w" do
      pg.w.should eq(pg.west)
    end
  end

  describe "north east" do
    subject { pg.north_east.to_ll }

    its(:lat) { should be_within(0.001).of(51.503) }
    its(:lon) { should be_within(0.001).of(-0.152) }
    it "should alias to ne" do
      pg.ne.should eq(pg.north_east)
    end
  end

  describe "north west" do
    subject { pg.north_west.to_ll }

    its(:lat) { should be_within(0.001).of(51.503) }
    its(:lon) { should be_within(0.001).of(-0.158) }
    it "should alias to nw" do
      pg.nw.should eq(pg.north_west)
    end
  end

  describe "south east" do
    subject { pg.south_east.to_ll }

    its(:lat) { should be_within(0.001).of(51.497) }
    its(:lon) { should be_within(0.001).of(-0.152) }
    it "should alias to se" do
      pg.se.should eq(pg.south_east)
    end
  end

  describe "south west" do
    subject { pg.south_west.to_ll }

    its(:lat) { should be_within(0.001).of(51.497) }
    its(:lon) { should be_within(0.001).of(-0.158) }
    it "should alias to sw" do
      pg.sw.should eq(pg.south_west)
    end
  end

  its(:points) do
    should == [pg.north_east, pg.east, pg.south_east, pg.south_west, pg.west, pg.north_west]
  end

end
