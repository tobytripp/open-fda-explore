#!/usr/bin/env ruby -w
require "nokogiri"


class FaersDocument < Nokogiri::XML::SAX::Document
  attr_reader :element_stack
  CODES = {
    reporttype: {
      1 => "Spontaneous",
      2 => "Report from Study",
      3 => "Other",
      4 => "Not available to sender (unknown)",
    },
    reactionoutcome: {
      1 => "recovered/resolved",
      2 => "recovering/resolving",
      3 => "not recovered/not resolved",
      4 => "recovered/resolved with sequelae",
      5 => "fatal",
      6 => "unknown",
    },
    patientsex: {
      0 => "unknown",
      1 => "male",
      2 => "female",
      9 => "unspecified",
    },
    drugcharacterization: {
      1 => "suspect",
      2 => "concomitant",
      3 => "interacting",
    },
    patientonsetageunit: {
      801 => "Year",
      802 => "Month",
      803 => "Week",
      804 => "Day",
      805 => "Hour"
    },
    actiondrug: {
      1 => "Drug Withdrawn",
      2 => "Dose reduced",
      3 => "Dose Increased",
      4 => "Dose not changed",
      5 => "Unknown",
      6 => "Not applicable",
    }
  }

  PRINT_ELEMENTS = CODES.keys.map( &:to_s ).concat %w[
    drugindication medicinalproduct safetyreportid
    occurcountry companynumb patientonsetage
    reactionmeddrapt drugdosageform
  ]
  ELEMENTS = %w[safetyreport drug patient reaction].concat PRINT_ELEMENTS

  def initialize()
    @element_stack = []
    @count = 0
  end

  def start_element( name, attrs=[] )
    $DEBUG && puts( "---- start #{name} (#{element_stack.size})" )
    if ELEMENTS.include? name.downcase
      element_stack.push name
    end
  end

  def end_element( name )
    element_stack.pop if element_stack.last == name
    @count += 1
    $DEBUG && puts( "---- end #{name} (#{element_stack.size})" )
    exit 1 if @count > 500
  end

  def characters( string )
    return if element_stack.empty?
    return unless PRINT_ELEMENTS.include? element_stack.last

    puts "%22s: %-45s     # %s" % [
      element_stack.last,
      decode( element_stack.last, string ),
      element_stack,
    ]
  end

  def decode( key, value )
    return value unless CODES.has_key? key.to_sym
    CODES[key.to_sym][value.to_i]
  end
end

def main( *args )
  file = File.open( args.first || "resources/FAERS_2013Q4/xml/ADR13Q4.xml", "r" )
  parser = Nokogiri::XML::SAX::Parser.new FaersDocument.new
  parser.parse file
ensure
  file.close
end

if $0 == $PROGRAM_NAME
  main( *ARGV )
end
