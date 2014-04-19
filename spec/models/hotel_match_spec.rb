require 'spec_helper'

describe HotelMatch do

  it "should exist if source_id and match_id found" do
    m = HotelMatch.new
    m.source_id = "1"
    m.source_model = "Poi"
    m.match_id = "1"
    m.match_model = "Agoda"
    m.save

    b = {}
    b[:source_id] = 2
    b[:source_model] = "Poi"
    b[:match_id] = 3
    b[:match_model] = "Agoda"


    c = {}
    c[:source_id] = 1
    c[:source_model] = "Poi"
    c[:match_id] = 1
    c[:match_model] = "Agoda"

    result = HotelMatch.exists? b
    result.should be_false

    result = HotelMatch.exists? c
    result.should be_true
  end
end

