require 'airport'
describe Airport do

  let(:landed_plane) { Plane.new false }
  let(:flying_plane) { Plane.new true }

  context 'I want to instruct a plane to land at an airport' do 

    it 'Checks if the airport has the ability to land planes' do
      expect(subject).to respond_to(:land_plane)
    end

    it 'Checks that the airport has the ability to store multiple planes' do
      expect(subject.planes).to be_instance_of(Array)
    end

    it 'stores a plane in the airport when it has landed' do
      subject.land_plane(flying_plane)
      expect(subject.planes.length).to eq 1
    end

  end

  context 'I want to instruct a plane to take off from an airport and confirm that it is no longer in the airport' do

    before do
      allow(subject).to receive(:stormy?).and_return(false)
    end

    it 'Checks the airport has the ability to take off planes' do
      expect(subject).to respond_to(:take_off).with(1).argument
    end

    it 'Checks that planes can takeoff off from the airport' do
      subject.planes << landed_plane
      expect(subject.take_off(landed_plane)).to be_instance_of(Plane)
    end

    it 'Checks that the plane is recorded as having left the airport' do
      subject.planes << landed_plane
      subject.take_off(landed_plane)
      expect(subject.planes.length).to eq 0
    end

    it 'Checks that there are planes in the airport to take off' do
      expect { subject.take_off(landed_plane) }.to raise_error "There are no planes to take off"
    end

  end

  context "I want to prevent landing when the airport is full" do
    
    it "Checks an airport holds a capacity of over 1 plane" do
      expect(subject.hanger_capacity).to be > 0
    end

    it "Check application crashes if you try to land a plane while the airport is full" do
      subject.planes << flying_plane
      expect { subject.land_plane(flying_plane) }.to raise_error "Airport Full"
    end

  end

  context "I would like a default airport capacity that can be overridden as appropriate" do

    before do
      subject.hanger_capacity = 2
    end

    it "Checks that you are able to modify the airport capacity" do
      expect(subject.hanger_capacity).to eq 2
    end

    it "Checks that a modified capacity allows two planes to land" do
      2.times { subject.land_plane(Plane.new true) }
      expect(subject.planes.length).to eq 2
    end

    it "Checks that a modified capacity will still throw error if capacity is full" do
      expect { 3.times { subject.land_plane(Plane.new true) } }.to raise_error "Airport Full"
    end

  end

  context "I want to prevent takeoff when weather is stormy" do

    it 'Check if an error is raised when a plane tries to take off during stormy weather' do
      allow(subject).to receive(:stormy?).and_return(true)
      expect { subject.take_off(landed_plane) }.to raise_error "It's too stormy to take off"
    end

  end

  context "Edge Cases" do
    before do
      allow(subject).to receive(:stormy?).and_return(false)
    end

    it "doesn't allow a plane to take off if it is already flying" do
      expect { subject.take_off(flying_plane) }.to raise_error "This plane is already flying"
    end

    it "doesn't alow a plane to land if it is not flying" do
      expect { subject.land_plane(landed_plane) }.to raise_error "This plane has already landed"
    end
  
  end

end
