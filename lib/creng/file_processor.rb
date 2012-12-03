

module Creng

	 class FileProcessor



	 	def self.process(clean_path, options, accessible_resources)

      FileUtils.remove_dir "#{clean_path}/build"

      #raising build version
      FileProcessor.raiseDevBuildVersion clean_path

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

      FileProcessor.processManifest clean_path, accessible_resources do |manifest_text, accessible_resources_new|
        #changing web_accessible_resources array
        manifest_text = manifest_text.gsub(/(\"web_accessible_resources\")\s?\:\s?(\[.*\])/, "\"web_accessible_resources\": [#{accessible_resources_new.join(',')}]")
        #changing background object
        manifest_text = FileProcessor.processBackgroundPage clean_path, manifest_text
        #checking js/vendor dir
        manifest_text = FileProcessor.processFrameworks clean_path, manifest_text
        #checking options page
        manifest_text = FileProcessor.processOptionsPage clean_path, manifest_text




      end



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



    def self.processBackgroundPage path, manifest_text

      if File.file? "#{path}/build/html/background.html"
        background_page = "#{path}/build/html/background.html"
        background_persistent = false
      elsif File.file? "#{path}/build/html/background_persistent.html"
        background_page = "#{path}/build/html/background_persistent.html"
        #renaming to default
        File.rename background_page, "#{path}/build/html/background.html"
        background_persistent = true
      else
        background_page = nil
        background_persistent = nil
      end

      unless background_page.nil?
        manifest_text = manifest_text.gsub(/(\"persistent\")\s?\:\s?(true|false)/, "\"persistent\": #{background_persistent}")
      else
        manifest_text = manifest_text.gsub(/(\"background\")\s?\:\s?(\{(.|\n)*\}\,)/, "")
       
      end 
       

        puts "    processed html/background.html"
        manifest_text

    end


    def self.processManifest clean_path, accessible_resources

      manifest_text = File.read("#{clean_path}/build/manifest.json")

      accessible_resources_new = []

      accessible_resources.each do |res|
        accessible_resources_new.push("\"#{res}\"")
      end
      
      manifest_text = yield(manifest_text, accessible_resources_new) if block_given?

      File.open("#{clean_path}/build/manifest.json", 'w') do |f|
          f.write manifest_text
      end

      puts "    processed manifest.json"

    end


    def self.processFrameworks clean_path, manifest_text

      background_files = Dir["#{clean_path}/build/js/vendor/background/*.js"]
      content_files = Dir["#{clean_path}/build/js/vendor/content/*.js"]
      both_files = Dir["#{clean_path}/build/js/vendor/*.js"]


      content_pool = ["\"js/process.js\""]
      background_pool = []


      background_files.each do |file|
        if File.file? file
          background_pool.push "<script type='text/javascript' src='js/vendor/#{File.basename file}'></script>"
        end
      end
      FileUtils.mv background_files, "#{clean_path}/build/js/vendor"


      content_files.each do |file|
       if File.file? file
          content_pool.push "\"js/vendor/#{File.basename file}\""
        end
      end
      FileUtils.mv content_files, "#{clean_path}/build/js/vendor"

      both_files.each do |file|
       if File.file? file
          content_pool.push "\"js/vendor/#{File.basename file}\""
          background_pool.push "<script type='text/javascript' src='js/vendor/#{File.basename file}'></script>"
        end
      end

      FileUtils.remove_dir "#{clean_path}/build/js/vendor/content"
      FileUtils.remove_dir "#{clean_path}/build/js/vendor/background"


     #replacing for content scripts loaded frameworks 
    if content_pool.length
        manifest_text = manifest_text.gsub(/\"content_scripts\"\s*\:\s*?(?:.|\n)*\"js\"\s?\:\s*(\[(?:.|\n)*?\])/) { |m| m.gsub!($1, "[#{content_pool.join(',')}]") } 
    end

    #@TODO: background page logic handling (insert script tags into html)
    if background_pool.length
      FileProcessor.changeBackgroundPage clean_path, background_pool
    end
     


     manifest_text

    end


    def self.changeBackgroundPage clean_path, background_pool

      background_page_path = "#{clean_path}/build/html/background.html"

      background_page_text = File.read(background_page_path)

      background_page_text = background_page_text.gsub(/\<\/head\>/,"#{background_pool.join(' ')}</head>")

      File.open(background_page_path, 'w') do |f|
          f.write background_page_text
      end

    end


    def self.processOptionsPage clean_path, manifest_text

      options_page_path = "#{clean_path}/build/html/options.html"

      if File.file? options_page_path
        manifest_text = manifest_text.gsub(/\"manifest_version\"\s*\:\s*2\s*\,/, "\"manifest_text\": 2,\n \"options_page\": \"html/options.html\",")
        puts "    processed html/options.html"
      else
        manifest_text = manifest_text.gsub(/\"options_page\"\s*\:\s*\"html\/options\.html\"\,/, "")
        puts "    processed options page removing"
      end


      manifest_text
    end


    def self.raiseDevBuildVersion clean_path

      manifest_dev_path = "#{clean_path}/dev/manifest.json"
      manifest_text = File.read(manifest_dev_path)

      manifest_text = manifest_text.gsub(/\"version\"\s*\:\s*\"(.*)\"\,/) { 

        |text| 
          digits = $1.split '.'
          buildversion = digits[3].to_i + 1
          new_version = "#{digits[0]}.#{digits[1]}.#{digits[2]}.#{buildversion}"
          
          text.gsub($1, "#{new_version}")

      }
      
      File.open(manifest_dev_path, 'w') do |f|
          f.write manifest_text
      end

    end

      


	 end

end