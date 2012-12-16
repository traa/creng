

module Creng

	 class Feature

	 	def self.add projectpath, value

	 		if Feature.respond_to? "add#{value.capitalize}"
	 			Feature.send("add#{value.capitalize}", projectpath)
	 		else
	 			puts "unsupported feature"
	 		end

	 	end


	 	def self.addWebrequest projectpath

	 		puts "		adding webrequest feature to dev project"

	 		manifest_text = File.read("#{projectpath}/dev/manifest.json")

	 		manifest_text = manifest_text.gsub(/(\"webRequest\"\,?\n?|\"webRequestBlocking\"\,?\n?)/, "")

	 		manifest_text = manifest_text.gsub(Regexp.new('\"permissions\"\s*\:\s*\[(.*?)\]', Regexp::MULTILINE)) { |m| m.gsub!($1, "\n\"webRequest\",\n\"webRequestBlocking\",#{$1}") } 

	 		puts "		checking manifest.json"

	 		File.open("#{projectpath}/dev/manifest.json", 'w') do |f|
          		f.write manifest_text
      		end

	 		FileGenerator.generateWebrequest projectpath

	 		puts "		now you can simply include requestInspector file in your background scripts"
	 		puts "		"
	 		puts "		======================================================================="
	 		puts "		var inspector = require(\"./requestInspector\").requestInspector;"
	 		puts "		inspector.start();"
	 		puts "		======================================================================="

	 	end



	 end

end