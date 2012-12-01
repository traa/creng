
module Creng

	 class ContentJS < FileGenerator

	 	attr_reader :name
	 	attr_reader :path
	 	attr_reader :contents

	 	def initialize
	 		@name = 'content.js'
	 		@path = 'js'
	 	end

	 	def create
	 		puts "called create of #{@filename}"
	 	end

	 	def contents
	 		<<-"...".gsub!(/^ {16}/, '')
                console.log("content of my extension running!");
	 		...
	 	end



	 end


end