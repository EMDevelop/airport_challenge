class Airport

  def initialize
    @planes = []
  end

  attr_reader :planes

  def land_plane(plane)
    @planes << plane
  end

  def take_off(plane)
    record_departure
    true
  end

  private

  def record_departure
    @planes.delete_at(@planes.length - 1)
  end

end
