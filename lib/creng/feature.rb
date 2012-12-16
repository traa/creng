

module Creng

	 class Feature

	 	def initialize projectname
	 		@projectname = projectname
	 	end

	 	def add value

	 		if Feature.respond_to? "add#{value.capitalize}"
	 			#@send("add#{value.capitalize}")
	 			"add#{value.capitalize}".call
	 		else
	 			puts "unsupported feature"
	 		end

	 	end


	 	def addWebrequest

	 		puts "adding webrequest feature to dev project #{@projectname}"

	 		FileGenerator.generateWebrequest @projectname

	 	end



	 end

end