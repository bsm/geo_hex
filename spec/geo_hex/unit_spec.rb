require 'spec_helper'

describe GeoHex::Unit do

  subject do
    described_class[7]
  end

  its(:level)  { should == 7 }
  its(:size)   { should be_within(0.01).of(339.33) }
  its(:width)  { should be_within(0.01).of(2036.02) }
  its(:height) { should be_within(0.01).of(1175.49) }

end
