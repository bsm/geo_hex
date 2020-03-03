# frozen_string_literal: true

require 'spec_helper'

describe GeoHex::PP do
  let :point do
    described_class.new(-17_306, 6_710_328)
  end

  subject do
    point
  end

  its(:lat)   { should be_within(1).of(52) }
  its(:lon)   { should be_within(1).of(0) }
  its(:to_ll) { should be_instance_of(GeoHex::LL) }

  describe 'to_zone' do
    subject { point.to_zone(7) }

    it          { is_expected.to be_instance_of(GeoHex::Zone) }
    its(:level) { should == 7 }
    its(:x)     { should == 5700 }
    its(:y)     { should == 5717 }
    its(:easting)  { should be_within(1).of(-17_306) }
    its(:northing) { should be_within(1).of(6_710_328) }
  end
end
