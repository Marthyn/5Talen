module Cleaner
	def strip_html(input)
		input.gsub('/\<\/?.*\?/', '')
	end
	
class Person
	def initialize(first_name, last_name)
		@first_name = first_name
		@last_name = last_name
		@full_name = first_name + ' ' last_name
	end
	
end
