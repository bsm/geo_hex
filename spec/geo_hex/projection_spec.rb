require 'spec_helper'

describe GeoHex::Projection do

  subject do
    described_class.new(-17306, 6710328)
  end

  its(:lat)  { should be_within(1).of(52) }
  its(:lon) { should be_within(1).of(0) }

end
