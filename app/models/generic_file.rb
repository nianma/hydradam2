require 'rdf/ebu_core'

class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile

  property :media_duration, predicate: ::RDF::EbuCore.duration do |index|
    index.as :stored_searchable, :facetable
  end
end