require 'time'
require 'pp'

class Response
	
	HEADER_TYPES = {
		'date' => :time,
		'content-length' => :integer
	}
	
	def type_cast(header_name, header_value)
		case HEADER_TYPES[header_name]
			when :time
				Time.parse(header_value)
			when :integer
				header_value.to_i
			when nil
				header_value.strip
		end
	end
	
	def initialize
		@headers = {}
		@status = []
	end
	
	def parse_status(line)
		if match = /^HTTP\/1\.1\s+(\d+)\s+(.*)$/.match(line.strip)
			[match[1].to_i, match[2]]
		end
	end
	
	def status_code
		@status.first
	end
  
	def status_message
		@status.last
	end
	
	def headers
		@headers
	end
	
	def self.parse(input)
		response = new
		response.parse(input)
		response
	end
	
	def parse(input)
		lines = input.split("\n")
		lines.each do |line|
			if line.start_with?('HTTP')
				@status = parse_status(line)
			end
			if line.include? ":"
				parts = line.split(":", 2)
				key = parts[0].downcase.strip
				value = parts[1].strip
				
				@headers[key] = type_cast(key, value)
			end
		end	
	end
end

examples_directory = 'exercises/parsing-http-headers/examples'
Dir.glob(File.join(examples_directory, '*.txt')).each do |filename|
	response = Response.parse(File.read(filename))
	puts 'Status code: '+response.status_code.to_s
	puts 'Status message: '+response.status_message
	puts '--Headers--'
	puts ' '
	response.headers.each do |key, value|
		puts key 
		puts ' '
		puts value
		puts '------'
	end
end


 



