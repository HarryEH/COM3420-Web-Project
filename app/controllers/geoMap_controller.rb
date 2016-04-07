class GeomapController < ApplicationController

  def map
    @current_nav_identifier = :map
    @lat_lng = []
    @obj_array = []
    Record.all.each do |thing|
      #this check for the 'people' who didnt manage to click on the map when uploading
      if thing.latitude
        @lat_lng.append({lat: thing.latitude , lng: thing.longitude})
        @obj_array.append(thing)
      end
    end
  end
end