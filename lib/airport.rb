class Airport

  def initialize
    @planes = []
  end

  attr_reader :planes

  def land_plane(plane)
    @planes << plane
  end

  def take_off

  end

end
