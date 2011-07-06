require 'test/unit'
require 'c:\users\Marthyn\Desktop\Ruby\response.rb'

class TestResponse < Test::Unit::TestCase
 
  def setup
    @response = Response.new
  end
 
  def test_response
	examples_directory = 'exercises/parsing-http-headers/examples'
	Dir.glob(File.join(examples_directory, '*.txt')).each do |filename|
		response = Response.parse(File.read(filename))
		file = filename.split("/").last
		file = file.gsub('txt','rb')
		expected = File.read('exercises/parsing-http-headers/expected/'+file)
		assert_equal eval(expected), response.headers
	end    
  end
 
end