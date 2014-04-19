require 'spec_helper'
require 'fuzzystringmatch'
include FuzzyStringMatch

describe Fuzzy do

  #it "address test for lahvenstein" do
  #  source_address = "8 Halong Road, Baichay, Halong / Bai Chay"
  #  target_address = "10 Halong Road, Bai Chay Ward, Halong / Bai Chay"
  #
  #  levenshtein = Levenshtein.new("pattern")
  #  weight = "#{source_address}".levenshtein_similar("#{target_address}")
  #  weight.should be >= 0.95
  #end
  #
  #it "address test for jaro" do
  #  source_address = "8 Halong Road, Baichay, Halong / Bai Chay"
  #  target_address = "10 Halong Road, Bai Chay Ward, Halong / Bai Chay"
  #
  #  jaro = JaroWinkler.create(:native)
  #  weight = jaro.getDistance(source_address, target_address))
  #  weight.should be >= 0.95
  #end
  #
  #it "address test for lahvenstein" do
  #  source_address = "8 Halong Road, Baichay, Halong / Bai Chay"
  #  target_address = "10 Halong Road, Baichay, Halong / Bai Chay"
  #
  #  levenshtein = Levenshtein.new("pattern")
  #  weight = "#{source_address}".levenshtein_similar("#{target_address}")
  #  weight.should be >= 0.99
  #end
  #
  #it "address test for jaro" do
  #  source_address = "8 Halong Road, Baichay, Halong / Bai Chay"
  #  target_address = "10 Halong Road, Baichay, Halong / Bai Chay"
  #
  #  jaro = JaroWinkler.create(:native)
  #  weight = jaro.getDistance(source_address, target_address))
  #  weight.should be >= 0.99
  #end
  #
  #it "address test for lahvenstein 11 Halong Road vs 10 Halong Road" do
  #  source_address = "11 Halong Road"
  #  target_address = "10 Halong Road"
  #
  #  levenshtein = Levenshtein.new("pattern")
  #  weight = "#{source_address}".levenshtein_similar("#{target_address}")
  #  weight.should be >= 0.99
  #end

  it "address test for jaro 11 Halong Road vs 10 Halong Road" do
    source_address = "11 Halong Road"
    target_address = "10 Halong Road"

    jaro = JaroWinkler.create(:native)
    weight = jaro.getDistance(source_address, target_address))
    weight.should be >= 0.95
  end

  #it "address test for lahvenstein 10 Holong Road vs 10 Halong Road" do
  #  source_address = "10 Holong Road"
  #  target_address = "10 Halong Road"
  #
  #  levenshtein = Levenshtein.new("pattern")
  #  weight = "#{source_address}".levenshtein_similar("#{target_address}")
  #  weight.should be >= 0.99
  #end
  #
  #it "address test for jaro 10 Holong Road vs 10 Halong Road" do
  #  source_address = "10 Holong Road"
  #  target_address = "10 Halong Road"
  #
  #  jaro = JaroWinkler.create(:native)
  #  weight = jaro.getDistance(source_address, target_address))
  #  weight.should be >= 0.99
  #end
  #
  #it "address test for lahvenstein 8 Holong Road vs 10 Halong Road" do
  #  source_address = "8 Holong Road"
  #  target_address = "10 Halong Road"
  #
  #  levenshtein = Levenshtein.new("pattern")
  #  weight = "#{source_address}".levenshtein_similar("#{target_address}")
  #  weight.should be >= 0.99
  #end
  #
  #it "address test for jaro 8 Holong Road vs 10 Halong Road" do
  #  source_address = "8 Holong Road"
  #  target_address = "10 Halong Road"
  #
  #  jaro = JaroWinkler.create(:native)
  #  weight = jaro.getDistance(source_address, target_address))
  #  weight.should be >= 0.99
  #end

  it "should match name Koh Chang Grand Lagoona Hotel vs Koh Chang Grand Lagoona" do
    source_name = "Koh Chang Grand Lagoona Hotel"
    target_name = "Koh Chang Grand Lagoona"

    jaro = JaroWinkler.create(:native)
    weight = "#{source_name}".getDistance(source_address,"#{target_name}")
    weight.should be >= 0.95
  end

  #it "should match name Koh Chang Grand Lagoona Hotel vs Koh Chang Grand Lagoona" do
  #  source_name = "Legian Express Hotel"
  #  target_name = "Legian Village Hotel"
  #
  #  jaro = JaroWinkler.create(:native)
  #  weight = "#{source_name}".getDistance(source_address,"#{target_name}")
  #  weight.should be >= 0.95
  #end

end

