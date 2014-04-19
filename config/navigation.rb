# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation
  if Rails.env == "test"
    navigation.items do |primary|
      navigation.auto_highlight = true

      primary.item :home, 'Home', root_path
      countries = Country.all
      countries.each do |c|
        primary.item c.name.downcase.to_sym, c.name, country_path(c)
      end
      
    end
  else
    navigation.items do |primary|
      navigation.auto_highlight = true

      primary.item :home, 'Home', root_path
      primary.item :brunei, image_tag("icons/countries/16x11/BN.png", :size => "16x11") + ' Brunei', '/brunei'
      primary.item :cambodia, image_tag("icons/countries/16x11/KH.png", :size => "16x11") + ' Cambodia', '/cambodia'
      primary.item :hong_kong, image_tag("icons/countries/16x11/HK.png", :size => "16x11") + ' Hong Kong', '/hong_kong'
      primary.item :indonesia, image_tag("icons/countries/16x11/ID.png", :size => "16x11") + ' Indonesia', '/indonesia'
      primary.item :laos, image_tag("icons/countries/16x11/LA.png", :size => "16x11") + ' Laos', '/laos'
      primary.item :malaysia, image_tag("icons/countries/16x11/MY.png", :size => "16x11") + ' Malaysia', '/malaysia'
      primary.item :myanmar, image_tag("icons/countries/16x11/MM.png", :size => "16x11") + ' Myanmar', '/myanmar'
      primary.item :philippines, image_tag("icons/countries/16x11/PH.png", :size => "16x11") + ' Philippines', '/philippines'
      primary.item :singapore, image_tag("icons/countries/16x11/SG.png", :size => "16x11") + ' Singapore', '/singapore'
      primary.item :taiwan, image_tag("icons/countries/16x11/TW.png", :size => "16x11") + ' Taiwan', '/taiwan'
      primary.item :thailand, image_tag("icons/countries/16x11/TH.png", :size => "16x11") + ' Thailand', '/thailand'
      primary.item :vietnam, image_tag("icons/countries/16x11/VN.png", :size => "16x11") + ' Vietnam', '/vietnam'
      primary.item :china, image_tag("icons/countries/16x11/CN.png", :size => "16x11") + ' China', '/china'
      primary.item :japan, image_tag("icons/countries/16x11/JP.png", :size => "16x11") + ' Japan', '/japan'
      primary.item :south_korea, image_tag("icons/countries/16x11/KR.png", :size => "16x11") + ' South Korea', '/south_korea'
      primary.item :macau, image_tag("icons/countries/16x11/MO.png", :size => "16x11") + ' Macau', '/macau'
      primary.item :india, image_tag("icons/countries/16x11/IN.png", :size => "16x11") + ' India', '/india'
      primary.item :sri_lanka, image_tag("icons/countries/16x11/LK.png", :size => "16x11") + ' Sri Lanka', '/sri_lanka'

    end
  end

end
