require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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
	@email = params[:email]
	@textarea = params[:textarea]

		# хеш для валидации
	hh = { 	:email => 'Введите свой email',
			:textarea => 'Введите текст письма' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ""
		return erb :contacts
	end

	erb "Спасибо за обращение! Мы ответим Вам в самое ближайшее время."
end
