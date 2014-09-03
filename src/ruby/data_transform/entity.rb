require "edn"
require "forwardable"

module DataTransform
  class Entity
    @@id = 0
    attr_reader :data, :parent
    attr_accessor :name

    TYPES = %w[drug patient safetyreport reaction]
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
        0 => "patient.gender/unknown".to_sym,
        1 => "patient.gender/male".to_sym,
        2 => "patient.gender/female".to_sym,
        9 => "patient.gender/unspecified".to_sym,
      },
      drugcharacterization: {
        1 => "drug.characterization/suspect".to_sym,
        2 => "drug.characterization/concomitant".to_sym,
        3 => "drug.characterization/interacting".to_sym,
      },
      patientonsetageunit: {
        800 => "patient.age.unit/decade".to_sym,
        801 => "patient.age.unit/year".to_sym,
        802 => "patient.age.unit/month".to_sym,
        803 => "patient.age.unit/week".to_sym,
        804 => "patient.age.unit/day".to_sym,
        805 => "patient.age.unit/hour".to_sym
      },
      actiondrug: {
        1 => "Drug Withdrawn",
        2 => "Dose reduced",
        3 => "Dose Increased",
        4 => "Dose not changed",
        5 => "Unknown",
        6 => "Not applicable",
      },
      patientonsetage: ->(age) { age.to_f }
    }

    def self.type?( element )
      TYPES.include? element.downcase
    end

    def attribute?( element )
      CODES.keys.map( &:to_s ).concat( %w[
        patientonsetage reactionmeddrapt drugdosageform
        medicinalproduct drugindication
        safetyreportid
      ]).include? element
    end

    def initialize( name, parent=nil )
      @name = name
      @data = {}
      @id   = @@id += 1
      @parent = parent
    end

    def []=( key, value)
      puts "[#{key}] = #{value}" if $DEBUG

      return value unless attribute? key
      data[ to_key( key ) ] = decode( key, value )
    end

    def to_edn()
      edn = data.to_edn[0..-2]
      if parent
        edn += [",", ":#{to_key( parent.name )}", parent.id_tag].join( " " )
      end
      edn + ", :db/id #{id_tag}}"
    end

    def id_tag()
      "#db/id[:db.part/user #{@id}]"
    end

    private

    def decode( key, value )
      return value unless CODES.has_key? key.to_sym

      decoder = CODES[key.to_sym]
      if decoder.respond_to? :call
        decoder.call value
      else
        decoder.fetch value.to_i
      end
    end

    def to_key( element_name )
      {
        "patientonsetage"     => "patient/age".to_sym,
        "patientonsetageunit" => "patient/age.unit".to_sym,
        "patientsex"          => "patient/gender".to_sym,
        "medicinalproduct"    => "drug/product".to_sym
      }.fetch( element_name ) { "#{name}/#{element_name}".to_sym }
    end
  end
end
