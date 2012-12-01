
module Creng

	 class ProcessJS < FileGenerator

	 	attr_reader :name
	 	attr_reader :path
	 	attr_reader :contents

	 	def initialize
	 		@name = 'process.js'
	 		@path = 'js'
	 	end

	 	def create
	 		puts "called create of #{@filename}"
	 	end

	 	def contents

	 		<<-"...".gsub!(/^ {16}/, '')
                require.config({
  baseUrl:  chrome.extension.getURL('/js') 
});


require([
    "content"
  ], function() { 
      
  });
	...

	 	end



	 end


end