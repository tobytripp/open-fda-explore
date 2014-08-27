#!/usr/bin/env ruby
require "nokogiri"

require_relative "entity"

module DataTranslate
  class FaersDocument < Nokogiri::XML::SAX::Document
    attr_reader :element_stack, :entity_stack

    PRINT_ELEMENTS = %w[
    drugindication medicinalproduct safetyreportid
    occurcountry companynumb patientonsetage
    reactionmeddrapt drugdosageform
    ]
    ELEMENTS = %w[safetyreport drug patient reaction].concat PRINT_ELEMENTS

    def initialize()
      @element_stack = []
      @entity_stack  = []
      @count = 0
    end

    def start_element( name, attrs=[] )
      $DEBUG && puts( "---- start #{name} #{element_stack}" )
      element_stack.push name
      if Entity.type? name.downcase
        entity_stack.push Entity.new( name )
      end
    end

    def end_element( name )
      element_stack.pop if element_stack.last == name
      if entity && entity.name == name
        puts entity.to_edn
        entity_stack.pop
      end

      @count += 1
      $DEBUG && puts( "---- end #{name} (#{element_stack.size})" )
      exit 1 if @count > 500
    end

    def characters( string )
      return if element_stack.empty?
      return unless entity

      puts "%22s: %s # %s" % [
        element,
        string,
        element_stack,
      ] if $DEBUG

      entity[ element ] = string

      puts entity.inspect if $DEBUG
    end

    private

    def entity()
      entity_stack.last
    end

    def element()
      element_stack.last
    end
  end

end

def main( *args )
  file = File.open( args.first || "resources/FAERS_2013Q4/xml/ADR13Q4.xml", "r" )
  parser = Nokogiri::XML::SAX::Parser.new DataTranslate::FaersDocument.new
  parser.parse file
ensure
  file.close
end

if $0 == $PROGRAM_NAME
  main( *ARGV )
end
