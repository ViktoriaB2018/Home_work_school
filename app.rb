require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('SELECT * FROM Barbers WHERE name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
			if !is_barber_exists? db, barber
					db.execute 'INSERT INTO Barbers (name) VALUES (?)', [barber]
			end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'SELECT * FROM Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
				Users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, phone TEXT, datestamp TEXT, barber TEXT, color TEXT)'

	db.execute 'CREATE TABLE IF NOT EXISTS 
				Barbers (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)'

	seed_db db, ['Юдашкина Алина', 'Ливанов Антон', 'Божок Екатерина', 'Эндрю Макаров']

end

get '/' do
	erb :body			
end

get '/about' do
	erb :about
end
get '/visit' do
	erb :visit
end
get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@select_barber = params[:select_barber]
	@color = params[:color]

	# хеш для валидации
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:date_time => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :visit
	end

	db = get_db
	db.execute "INSERT INTO Users (username, phone, datestamp, barber, color) 
	            VALUES (?, ?, ?, ?, ?)", [@username, @phone, @date_time, @select_barber, @color]

	erb "Спасибо, #{@username}, #{@phone}! Вы записаны на #{@date_time} к #{@select_barber}, цвет #{@color}."
end

get '/showusers' do
	db = get_db
	@results = db.execute 'SELECT * FROM Users order by id desc'
	erb :showusers
end

post '/contacts' do
	@name = params[:name]
	@email = params[:email]
	@textarea = params[:textarea]

		# хеш для валидации
	hh = { 	:name => 'Введите свое имя',
			:email => 'Введите email',
			:textarea => 'Введите текст письма' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		require 'pony'
		Pony.mail(
		  :name => params[:name],
		  :email => params[:email],
		  :textarea => params[:textarea],
		  :to => 'vikavebmaster@gmail.com',
		  :subject => params[:name] + " has contacted you",
		  :body => params[:textarea],
		  :port => '587',
		  :via => :smtp,
		  :via_options => { 
		    :address              => 'smtp.gmail.com', 
		    :port                 => '587', 
		    :enable_starttls_auto => true, 
		    :user_name            => 'vikavebmaster@gmail.ru', 
		    :password             => '123456789qaRf', 
		    :authentication       => :plain, 
		    :domain               => 'localhost.localdomain'
		  })

		erb "Спасибо за обращение! Мы ответим Вам в самое ближайшее время."
	end
end



