SOURCE_FILE = "resources/FAERS_2013Q4/xml/ADR13Q4.xml"
$LOAD_PATH.unshift "src"

require "data_translate/convert"

task default: "resources/faers.edn"

file "resources/faers.edn" => SOURCE_FILE do |t|
  File.open( SOURCE_FILE, "r" ) do |f|
    parser = Nokogiri::XML::SAX::Parser.new DataTranslate::FaersDocument.new
    parser.parse file
  end
end
