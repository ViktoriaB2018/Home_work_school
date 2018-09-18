require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS 
				Users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, phone TEXT, datestamp TEXT, barber TEXT, color TEXT)'
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

	erb "Спасибо, #{@username}, #{@phone}! Вы записаны на #{@date_time} к #{@select_barber}, цвет #{@color}."
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



