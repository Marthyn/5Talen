module HTTPheaderparser

	class HTTPheader
		def part1()
			text= "HTTP/1.1 200 OK
				   Date: Sun, 25 Apr 2010 12:17:38 GMT
				   Server: Apache/2.2.14 (Unix)
				   Content-Length: 44
				   Content-Type: text/html"
			list = {}
			lines = text.split("\n")
			lines.each do |line|
				if line.include? ":"
					parts = line.split(":", 2)
					key = parts[0].downcase.strip
					value = parts[1].strip
					
					list[key] = value
				end
			end	
			list
		end
		
		def part2(path)
			list = {}
			lines = File.read(path).split("\n")
			lines.each do |line|
				if line.include? ":"
					parts = line.split(":", 2)
					key = parts[0].downcase.strip
					value = parts[1].strip
					
					list[key] = value
				end
			end	
			list
		end
		
		require 'time'
		
		HEADERS_TYPE_MAP = {
		  'date'           => :time,
		  'content-length' => :integer
		}
		
		def type_cast(header_name, header_value)
			case HEADERS_TYPE_MAP[header_name]
			when :time
				Time.parse(header_value)
			when :integer
				header_value.to_i
			when nil
				header_value.strip
			end
		end
		
		def part3(dir)
			files = []
			Dir.glob(File.join(dir, '*.txt')).each do |filename|
				files.push (filename)
			end
			
			output = []
			
			files.each do |file|
				list = {}
				lines = File.read(file).split("\n")
				lines.each do |line|
					if line.include? ":"
						parts = line.split(":", 2)
						key = parts[0].downcase.strip
						value = parts[1].strip
						
						list[key] = type_cast(key, value)
					end
				end	
				output.push(list)
			end
			output
		end
	end
end
require 'pp'			
parser = HTTPheaderparser::HTTPheader.new
pp parser.part1
pp "--------"
pp parser.part2("exercises/parsing-http-headers/examples/001-simple.txt")
pp "--------"
output = parser.part3("exercises/parsing-http-headers/examples")
output.each do |list|
	list.each {|key, value| puts "#{key} : #{value}" }
end


