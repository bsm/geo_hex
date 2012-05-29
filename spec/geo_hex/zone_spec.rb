require 'spec_helper'

describe GeoHex::Zone do

  subject do
    GeoHex.encode(0, 0, 7)
  end

  it { should be_instance_of(described_class) }
  it { should be_a(String) }
  its(:level) { should == 7 }
  its(:to_hash) { should == { lat: 0.0, lon: 0.0, level: 7 } }

end
