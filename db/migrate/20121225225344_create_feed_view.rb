class CreateFeedView < ActiveRecord::Migration
  def self.up
    execute "CREATE or REPLACE VIEW feeds AS
          SELECT l.created_at, u.profile_id, u.first_name, u.last_name, 'like this' as content, l.poi_id, p.name, p.country_name, p.country_id
          FROM likes l, facebook_users u, pois p
          WHERE l.profile_id = u.profile_id AND l.poi_id = p.id
        UNION
          SELECT c.created_at,  u.profile_id, u.first_name, u.last_name, c.content, c.poi_id, p.name, p.country_name, p.country_id
          FROM facebook_users u, comments c, pois p
          WHERE u.profile_id = c.profile_id AND c.poi_id = p.id"
  end

  def self.down
    execute "DROP VIEW IF EXISTS feeds;"
  end
end
