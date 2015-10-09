# -*- ruby -*-
#--
# Copyright 2008 Danny Coates, Ashkan Farhadtouski
# All rights reserved.
# See LICENSE for permissions.
#++
# AUTOGENERATED ComplexType

module HealthVault
  module WCData
  module Thing
  module Labtestresults
  
      class Labtestresulttype < ComplexType
        
     
        
        
       
        
        #<b>summary</b>: The date of the laboratory test.
#<em>value</em> is a HealthVault::WCData::Dates::Approxdatetime
        def when=(value)
          @children['when'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Approxdatetime
        def when
          return @children['when'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The name of the laboratory test.
#<em>value</em> is a String
        def name=(value)
          @children['name'][:value] = value
        end
        
        #<b>returns</b>: a String
        def name
          return @children['name'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The substance tested.
#<b>preferred-vocabulary</b>: Contact the HealthVault team to help define this vocabulary.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def substance=(value)
          @children['substance'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def substance
          return @children['substance'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The collection method for the laboratory test.
#<b>preferred-vocabulary</b>: Contact the HealthVault team to help define this vocabulary.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def collection_method=(value)
          @children['collection-method'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def collection_method
          return @children['collection-method'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The clinical code for the laboratory test.
#<b>preferred-vocabulary</b>: LOINC
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def clinical_code=(value)
          @children['clinical-code'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def clinical_code
          return @children['clinical-code'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: A clinical value within a laboratory result.
#<b>remarks</b>: This type is define a clinical value within a laboratory result, including value, unit, reference and toxic ranges.
#<em>value</em> is a HealthVault::WCData::Thing::Labtestresults::Labtestresultvaluetype
        def value=(value)
          @children['value'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Labtestresults::Labtestresultvaluetype
        def value
          return @children['value'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The status of the laboratory result.
#<b>remarks</b>: Examples of status include complete and pending.
#<b>preferred-vocabulary</b>: lab-status
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def status=(value)
          @children['status'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def status
          return @children['status'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: A note that augments the laboratory result.
#<b>remarks</b>: There are two scenarios in which a note is typically added: A note may provide additional information about interpreting the result beyond what is stored in the ranges associated with the value. Or, a note may be use to provide the textual result of a lab test that does not have a measured value. Formatting: Notes may come from systems that require a line-based approach to textual display. To support this, applications should render the spaces and newlines in the note, and use a fixed-width font. The form transform for this type shows one way to do this.
#<b>preferred-vocabulary</b>: lab-status
#<em>value</em> is a String
        def note=(value)
          @children['note'][:value] = value
        end
        
        #<b>returns</b>: a String
        def note
          return @children['note'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'lab-test-result-type'
        
          
          @children['when'] = {:name => 'when', :class => HealthVault::WCData::Dates::Approxdatetime, :value => nil, :min => 0, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          
        
          
          @children['name'] = {:name => 'name', :class => String, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['substance'] = {:name => 'substance', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['collection-method'] = {:name => 'collection-method', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
          
          @children['clinical-code'] = {:name => 'clinical-code', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['value'] = {:name => 'value', :class => HealthVault::WCData::Thing::Labtestresults::Labtestresultvaluetype, :value => nil, :min => 0, :max => 1, :order => 6, :place => :element, :choice => 0 }
            
          
        
          
          @children['status'] = {:name => 'status', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 7, :place => :element, :choice => 0 }
            
          
        
          
          @children['note'] = {:name => 'note', :class => String, :value => nil, :min => 0, :max => 1, :order => 8, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
