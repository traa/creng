#!/bin/env ruby
# encoding: utf-8

require "creng/version"
require "fileutils"
require "rdf/cli"

module Creng

 autoload :FileGenerator, 'creng/file_generator'
 autoload :FileProcessor, 'creng/file_processor'
 autoload :FileTweaker, 'creng/file_tweaker'
 autoload :Feature, 'creng/feature'

 autoload :ProcessJS, 'creng/files/processjs'
 autoload :DaemonJS, 'creng/files/daemonjs'
 autoload :ContentJS, 'creng/files/contentjs'
 autoload :BackgroundJS, 'creng/files/backgroundjs'

 class Generator
    
    def run(args)

      options = {}
      @optparser = RDF::CLI.options do
	      self.on('-n', '--nodefine',   'Init or build without define statements') do
	          options[:nodefine] = true
	       end

	       self.on('-c', '--noconsole',   'Build without debug messages(console.* calls)') do
	          options[:noconsole] = true
	       end

         self.on('-b', '--withdevblock', 'Build and extension with blocks of code for development purposes') do
            options[:withdevblock] = true
         end

	  end
	  args = ARGV
	  @options = options

      if !public_methods(false).map(&:to_s).include?(args[0])
      	puts "unknown command #{args.first}"
      else
      	run_command(args) unless args.empty?
      end
    end

    def run_command(args)
    	self.send(*args)
    end

    def debug
    	puts @projectname
    end


    def init(*args)
      projectname = args.first
    	if File.directory? projectname
    		puts "		project directory already exists"
    	else

	    	puts "		initialized project with name #{projectname}"

	    	puts "		create #{projectname}/dev/js/vendor/content"
	    	FileUtils.mkdir_p "#{projectname}/dev/js/vendor/content"

        	puts "        create #{projectname}/dev/js/vendor/utils"
        	FileUtils.mkdir_p "#{projectname}/dev/js/vendor/utils"

        	puts "        create #{projectname}/dev/js/vendor/background"
        	FileUtils.mkdir_p "#{projectname}/dev/js/vendor/background"

	    	puts "		create #{projectname}/dev/images"
	    	FileUtils.mkdir_p "#{projectname}/dev/images"

	    	puts "		create #{projectname}/dev/html"
	    	FileUtils.mkdir_p "#{projectname}/dev/html"

	    	puts "		create #{projectname}/dev/js"
	    	FileUtils.mkdir_p "#{projectname}/dev/js/"

	    	puts "		create #{projectname}/build"
	    	FileUtils.mkdir_p "#{projectname}/build"

	  	FileGenerator.new projectname

	       	
        end
    end



  	def build
     
  		FileProcessor.inProjectDir do |curdir|
        FileProcessor.process curdir, @options, FileGenerator.getAccessibleResources()
      end
  		#curdir_match_project = (curdir =~ Regexp.new("\/#{projectname}(\/)?.*$")) #Regexp.escape(var))) #/­/)


  		# unless curdir_match_project.nil?
  		# 	clean_path = curdir[0..(curdir_match_project+projectname.length)]
  		
  		# 	FileProcessor.process clean_path, @options, FileGenerator.getAccessibleResources()

  		# end


  	end


    def feature(*args)
      action = args.first
      value = args[1]

      if Feature.respond_to? action
        Feature.send(action, value)
      else
        puts "feature action not supported"
      end


    end


    def help(command = nil)
  		puts @optparser
  		#puts @options
  		puts
      	puts "Commands:"
      	puts "    help        Shows this help."
      	puts "    init <project_name>       Initialize new project"
      	puts "	  build <project_name>	building project with given options"
        puts "    feature <add|remove>  adding or removing feature to/from project"
  	end


  end
end
