

module Creng

	 class FileProcessor



	 	def self.process(clean_path, options, accessible_resources)

      FileUtils.remove_dir "#{clean_path}/build"
      FileUtils.copy_entry "#{clean_path}/dev", "#{clean_path}/build", false, true


      files = Dir["#{clean_path}/dev/js/*.js"]

      files.each do |file|

        text = File.read(file)
        filename = File.basename(file)

        exclusions_from_defining = ['process.js', 'daemon.js']

        #if define is allowed
        if !options[:nodefine]
          unless exclusions_from_defining.include? filename
            text = "#{FileProcessor.preDefine}#{text}#{FileProcessor.postDefine}"

            clean_path_for_regex = clean_path.gsub(/\//, '\/')

            buildpath = file.gsub(Regexp.new("#{clean_path_for_regex}\/dev"), "#{clean_path}/build")


            File.open(buildpath, 'w') do |f|
              f.write text
            end

            puts "    processed js/#{filename}"

          end
        end
        #endof if define allowed


      end
      #endof files loop

      manifest_text = File.read("#{clean_path}/build/manifest.json")

      accessible_resources_new = []

      accessible_resources.each do |res|
        accessible_resources_new.push("\"#{res}\"")
      end
      #puts "ac res #{accessible_resources_new}, #{accessible_resources}"
      manifest_text = manifest_text.gsub(/(\"web_accessible_resources\")\s?\:\s?(\[.*\])/, "\"web_accessible_resources\": [#{accessible_resources_new.join(',')}]")
      
      File.open("#{clean_path}/build/manifest.json", 'w') do |f|
          f.write manifest_text
      end

      puts "    processed manifest.json"

	 	end


    def self.preDefine
      <<-"...".gsub!(/^ {12}/, '')
            define(function(require) { exports = {};
(function() {
      ...
    end


    def self.postDefine
      <<-"...".gsub!(/^ {12}/, '')
            }).call(this);
return exports;});
      ...
    end


    def self.inProjectDir

        curdir = Dir.pwd
      
        if (['dev', 'build'] & Dir.entries(curdir).select { |file| File.directory? File.join(curdir, file)}).length == 2
          yield curdir if block_given?
        else
          puts "you must be in project directory"
        end

    end




	 end

end