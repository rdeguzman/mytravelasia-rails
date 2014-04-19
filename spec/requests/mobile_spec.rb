require 'spec_helper'

describe 'Mobile' do

  describe 'get updates' do

    it 'should be successful response' do
      Country.all.each do |country|
        visit mobileupdates_path({:format => :json,:country_name => country.country_name})

        json = JSON.parse(page.source)
        json['front_page'].should_not be_nil
        json['categories'].should_not be_nil
        json['buttons'].should_not be_nil

        json['top_destinations'].should be_a_kind_of(Array)
        json['destinations'].should be_a_kind_of(Array)
        json['ads'].should be_a_kind_of(Array)
      end
    end

    it 'should have front_page' do
      Country.all.each do |country|
        visit mobileupdates_path({:format => :json,:country_name => country.country_name})
        json = JSON.parse(page.source)
        json['front_page'].include? "#{country.country_name}".should be_true
      end
    end

    it 'should have categories' do
      Country.all.each do |country|
        visit mobileupdates_path({:format => :json,:country_name => country.country_name})
        page.source.include?('"categories"')
      end
    end

    it 'should have buttons' do
      Country.all.each do |country|
        visit mobileupdates_path({:format => :json,:country_name => country.country_name})
        page.source.include?('"buttons"')
      end
    end

    it 'should have top_destinations' do
      Country.all.each do |country|
        visit mobileupdates_path({:format => :json,:country_name => country.country_name})
        page.source.include?('"top_destinations"')
      end
    end

    it 'should have destinations' do
      Country.all.each do |country|
        visit mobileupdates_path({:format => :json,:country_name => country.country_name})
        page.source.include?('"destinations"')
      end
    end

  end

  it 'have recent' do
    Country.all.each do |country|
      visit recent_path({:format => :json,:country_name => country.country_name})

      json = JSON.parse(page.source)
      json['total_pages'].should be_a_kind_of(Fixnum)
      json['data'].should be_a_kind_of(Array)
    end
  end

  it 'have featured' do
    Country.all.each do |country|
      visit featured_path({:format => :json,:country_name => country.country_name})

      json = JSON.parse(page.source)
      json['total_pages'].should be_a_kind_of(Fixnum)
      json['data'].should be_a_kind_of(Array)
    end
  end

  it 'have most_viewed' do
    Country.all.each do |country|
      visit most_viewed_path({:format => :json,:country_name => country.country_name})

      json = JSON.parse(page.source)
      json['total_pages'].should be_a_kind_of(Fixnum)
      json['data'].should be_a_kind_of(Array)
    end
  end

  it 'has nearby' do
    visit nearby_path({:format => :json,:country_name => 'Philippines',
                       :latitude => 14.651499, :longitude => 121.049322})

    json = JSON.parse(page.source)
    json['total_pages'].should be_a_kind_of(Fixnum)
    json['data'].should be_a_kind_of(Array)
  end

  it 'has valid poi details pois/:id' do
    poi = Poi.where(:poi_type_name => 'hotel').first
    visit poi_path(:id => poi.id, :format => 'json')

    json = JSON.parse(page.source)
    json.should be_a_kind_of(Hash)
  end

  describe 'facebook feed' do
    it 'has no feed for country_name' do
      visit feed_path(:country_name => 'Bangladesh', :format => 'json')
      json = JSON.parse(page.source)
      json.should be_a_kind_of(Hash)
      json['total_pages'].should == 0
      json['data'].count.should == 0
    end

    it 'has feed for country_name' do
      visit feed_path(:country_name => 'Philippines', :format => 'json')
      json = JSON.parse(page.source)
      json.should be_a_kind_of(Hash)
      json['total_pages'].should > 0
      json['data'].count.should > 0
    end

  end

end