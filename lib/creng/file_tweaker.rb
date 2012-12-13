module Creng

	 class FileTweaker

	 	#cutting blocks of code, marked as ###devblock_begin and ###devblock_end
	 	#returns modified text of file
	 	def self.cutDevBlock path, text, filename

	 		text = text.gsub(/\/\/devblock_begin(.|\n)*?\/\/devblock_end/, "")

	 		text
	 	end


	 	#cutting all console.* calls
	 	def self.cutDebugMessages


	 	end

	 end

end