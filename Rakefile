# -*- mode: ruby -*-
SOURCE_FILE = "resources/FAERS_2013Q4/xml/ADR13Q4.xml"
$LOAD_PATH.unshift "src/ruby"

require "data_transform/convert"

task default: "resources/faers.edn"

file "resources/faers.edn" => SOURCE_FILE do |t|
  File.open( SOURCE_FILE, "r" ) do |f|
    parser = Nokogiri::XML::SAX::Parser.new DataTranslate::FaersDocument.new
    parser.parse file
  end
end

desc "Start a Clojure REPL on port 4343"
task :repl do
  sh "lein repl :headless :host 0.0.0.0 :port 4343"
end
