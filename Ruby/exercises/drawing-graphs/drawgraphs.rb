class DrawGraphs
	
	require 'chunky_png'
	
	def draw_base()
		@image = ChunkyPNG::Image.new(64, 65, ChunkyPNG::Color.from_hex('#000000'))
	end
	
	def save_image()
		@image.save('filename.png')
	end
	
	def draw_graph()
		i=0
		@numbers.each_with_index do |value, x|
			value = value.to_f
			y = 32 + ((value / 100.0) * 31).round
			@image.line(x, 32, x, y, ChunkyPNG::Color.rgba(255, 0, 0, 255))
		end
		@image.line(0, 32, 65, 32, ChunkyPNG::Color.from_hex('#ffffff'))
	end
	
	def read_data(path)
		file = File.read(path)
		@numbers = file.split("\n")
	end	
	
	def numbers
		@numbers
	end
end

grapher = DrawGraphs.new
grapher.read_data("examples/001-sinus.txt")
p grapher.numbers
grapher.draw_base()
grapher.draw_graph()
grapher.save_image()