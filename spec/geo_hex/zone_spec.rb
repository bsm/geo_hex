require 'spec_helper'

describe GeoHex::Zone do

  let(:zone) { GeoHex.encode(51, 0, 7) }
  subject    { zone }

  it { should be_instance_of(described_class) }
  it { should be_a(String) }
  its(:level) { should == 7 }
  its(:lat) { should be_within(0.1).of(51) }
  its(:lon) { should == 0 }
  its(:x) { should == 5633 }
  its(:y) { should == 5633 }
  its(:to_hash) { should == { lat: zone.lat, lon: zone.lon, level: 7, x: 5633, y: 5633 } }

end
