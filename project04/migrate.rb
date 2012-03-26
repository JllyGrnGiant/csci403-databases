#!/usr/bin/env ruby

require 'sqlite3'

# constants
FILENAME = 'wine.db'

# open database
db = SQLite3::Database.new(FILENAME);

# migrate information
db.execute('select name, winery_name, vinyard_name, region_name, country_name, grape_name, vintage, price, purchase_date, drunk_date, rating, comment from wines_tmp;').each do |wine_name, winery_name, vineyard_name, region_name, country_name, grape_name, vintage, price, purchase_date, drunk_date, rating, comment|
	
	# countries
	unless country_name.nil?
		if db.get_first_value('select count(*) from countries where name = ?;', country_name) == 0
			db.execute('insert into countries(name) values(?)', country_name);
		end
		cid = db.get_first_value('select id from countries where name = ?;', country_name)
	else
		cid = nil
	end
	
	# regions
	unless region_name.nil?
		if db.get_first_value('select count(*) from regions where name = ?;', region_name) == 0
			db.execute('insert into regions(name, country_id) values(?, ?)', region_name, cid);
		end
		rid = db.get_first_value('select id from regions where name = ?;', region_name)
	else
		rid = nil
	end
	
	# grapes
	grapes = grape_name.split(',')
	for i in 0...grapes.length
		grapes[i] = grapes[i].strip

		unless grapes[i].nil?
			if db.get_first_value('select count(*) from grapes where name = ?;', grapes[i]) == 0
				db.execute('insert into grapes(name) values(?)', grapes[i]);
			end
		end
	end

	# wineries
	unless winery_name.nil?
		if db.get_first_value('select count(*) from wineries where name = ?;', winery_name) == 0
			db.execute('insert into wineries(tax_id, name) values(NULL, ?)', winery_name);
		end
		wyid = db.get_first_value('select id from wineries where name = ?;', winery_name)
	else
		wyid = nil
	end

	# vineyards
	unless vineyard_name.nil?
		if db.get_first_value('select count(*) from vineyards where name = ?;', vineyard_name) == 0
			db.execute('insert into vineyards(parcel_id, name, region_id, winery_id) values(NULL, ?, ?, ?)', vineyard_name, rid, wyid);
		end
		vid = db.get_first_value('select id from vineyards where name = ?;', vineyard_name)
	else
		vid = nil
	end
	
	# wines
	unless wine_name.nil?
		if db.get_first_value('select count(*) from wines where name = ?;', wine_name) == 0
			db.execute('insert into wines(sku, name, vintage, price, purchase_date, drunk_date, rating, comment, winery_id) values(NULL, ?, ?, ?, ?, ?, ?, ?, ?)', wine_name, vintage, price, purchase_date, drunk_date, rating, comment, wyid);
		end
		weid = db.get_first_value('select id from wines where name = ?;', wine_name)
	else
		weid = nil
	end

	# join tables
	grapes.each do |grape|
		unless grape.nil?
			gid = db.get_first_value('select id from grapes where name = ?;', grape)

			# grapes - vineyards join table
			unless vid.nil?
				if db.get_first_value('select count(*) from grapes_vineyards where grape_id = ? and vineyard_id = ?;', gid, vid) == 0
					db.execute('insert into grapes_vineyards(grape_id, vineyard_id) values(?, ?)', gid, vid);
				end
			end

			# grapes - wines join table
			unless weid.nil?
				if db.get_first_value('select count(*) from grapes_wines where grape_id = ? and wine_id = ?;', gid, weid) == 0
					db.execute('insert into grapes_wines(grape_id, wine_id) values(?, ?)', gid, weid);
				end
			end
		end
	end
end
	

# close database
db.close()
