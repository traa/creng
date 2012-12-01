
module Creng

	 class DaemonJS < FileGenerator

	 	attr_reader :name
	 	attr_reader :path
	 	attr_reader :contents

	 	def initialize
	 		@name = 'daemon.js'
	 		@path = 'js'
	 	end

	 	def create
	 		puts "called create of #{@filename}"
	 	end

	 	def contents

	 		<<-"...".gsub!(/^ {16}/, '')
                require.config({
  baseUrl: '/js' 
});


require([
    "background"
  ], function() { 
      
  });

	...
	 	end



	 end


end