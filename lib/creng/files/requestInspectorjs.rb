
module Creng

	 class RequestInspectorJS < FileGenerator

	 	attr_reader :name
	 	attr_reader :path
	 	attr_reader :contents

	 	def initialize
	 		@name = 'requestInspector.js'
	 		@path = 'js'
	 	end

	 	def create
	 		puts "called create of #{@filename}"
	 	end

	 	def contents
	 		<<-"...".gsub!(/^ {2}/, '')
  RequestInspector = function(instanceId) {
  	//some init logic here
  };

  //Method, which must be executed to start listening of network requests
  RequestInspector.prototype.start = function() {
      var self = this;
      chrome.webRequest.onBeforeRequest.addListener(function (details) {
        return RequestInspector.inspect(self, details);
      }, {urls: ['<all_urls>']}, ['blocking']);
  };

  //Method, that receives every request made.
  //It can cancel it or redirect. For cancel, it must return {cancel: true} object, for redirect {redirectUrl: url} object
  RequestInspector.prototype.inspect = function(instance, details) {
  	console.log("inspected request object", details)
  };

  //this line is important for included scripts via require
  exports.RequestInspector = RequestInspector;

	 		...
	 	end



	 end


end