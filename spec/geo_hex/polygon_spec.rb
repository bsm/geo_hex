# frozen_string_literal: true

require 'spec_helper'

describe GeoHex::Polygon do
  let(:pg) { GeoHex.decode('QE0166383').polygon }
  subject  { pg }

  describe 'centroid' do
    subject { pg.centroid.to_ll }

    its(:lat) { should be_within(10**-6).of(51.500613) }
    its(:lon) { should be_within(10**-6).of(-0.155464) }
    it 'should alias to c' do
      expect(pg.c).to eq(pg.centroid)
    end
  end

  describe 'east' do
    subject { pg.east.to_ll }

    its(:lat) { should be_within(10**-6).of(51.500613) }
    its(:lon) { should be_within(10**-6).of(-0.149367) }
    it 'should alias to e' do
      expect(pg.e).to eq(pg.east)
    end
  end

  describe 'west' do
    subject { pg.west.to_ll }

    its(:lat) { should be_within(10**-6).of(51.500613) }
    its(:lon) { should be_within(10**-6).of(-0.161560) }
    it 'should alias to w' do
      expect(pg.w).to eq(pg.west)
    end
  end

  describe 'north east' do
    subject { pg.north_east.to_ll }

    its(:lat) { should be_within(10**-6).of(51.503899) }
    its(:lon) { should be_within(10**-6).of(-0.152415) }
    it 'should alias to ne' do
      expect(pg.ne).to eq(pg.north_east)
    end
  end

  describe 'north west' do
    subject { pg.north_west.to_ll }

    its(:lat) { should be_within(10**-6).of(51.503899) }
    its(:lon) { should be_within(10**-6).of(-0.158512) }
    it 'should alias to nw' do
      expect(pg.nw).to eq(pg.north_west)
    end
  end

  describe 'south east' do
    subject { pg.south_east.to_ll }

    its(:lat) { should be_within(10**-6).of(51.497326) }
    its(:lon) { should be_within(10**-6).of(-0.152415) }
    it 'should alias to se' do
      expect(pg.se).to eq(pg.south_east)
    end
  end

  describe 'south west' do
    subject { pg.south_west.to_ll }

    its(:lat) { should be_within(10**-6).of(51.497326) }
    its(:lon) { should be_within(10**-6).of(-0.158512) }
    it 'should alias to sw' do
      expect(pg.sw).to eq(pg.south_west)
    end
  end

  describe 'north' do
    subject { pg.north.to_ll }

    its(:lat) { should be_within(10**-6).of(51.503899) }
    its(:lon) { should be_within(10**-6).of(-0.155464) }
    it 'should alias to n' do
      expect(pg.n).to eq(pg.north)
    end
  end

  describe 'south' do
    subject { pg.south.to_ll }

    its(:lat) { should be_within(10**-6).of(51.497326) }
    its(:lon) { should be_within(10**-6).of(-0.155464) }
    it 'should alias to s' do
      expect(pg.s).to eq(pg.south)
    end
  end

  its(:points) do
    should == [pg.north_east, pg.east, pg.south_east, pg.south_west, pg.west, pg.north_west]
  end
end
