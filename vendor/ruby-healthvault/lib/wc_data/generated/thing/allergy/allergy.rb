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
  module Allergy
  
      class Allergy < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The name of the allergy.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def name=(value)
          @children['name'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def name
          return @children['name'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: A description of a typical reaction to the allergen.
#<b>preferred-vocabulary</b>: icd9cm
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def reaction=(value)
          @children['reaction'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def reaction
          return @children['reaction'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The approximate date and time when the allergy was first observed.
#<em>value</em> is a HealthVault::WCData::Dates::Approxdatetime
        def first_observed=(value)
          @children['first-observed'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Approxdatetime
        def first_observed
          return @children['first-observed'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The allergen type provides a general category of the source of the allergic reaction.
#<b>remarks</b>: Examples include medication (penicillin, sulfonamides, etc.), food (peanuts, shell fish, wheat, etc.), animal (bee stings, canine, feline, etc.), plants (ragweed, birch, etc.), environmental (smoke, smog, dust, etc.).
#<b>preferred-vocabulary</b>: allergen-type
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def allergen_type=(value)
          @children['allergen-type'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def allergen_type
          return @children['allergen-type'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The clinical allergen code.
#<b>preferred-vocabulary</b>: icd9cm
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def allergen_code=(value)
          @children['allergen-code'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def allergen_code
          return @children['allergen-code'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Information about the treatment provider for this allergy.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Person
        def treatment_provider=(value)
          @children['treatment-provider'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Person
        def treatment_provider
          return @children['treatment-provider'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The possible treatment description for this allergy.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def treatment=(value)
          @children['treatment'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def treatment
          return @children['treatment'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: True if the allergic reation is negated with treatment.
#<em>value</em> is a String
        def is_negated=(value)
          @children['is-negated'][:value] = value
        end
        
        #<b>returns</b>: a String
        def is_negated
          return @children['is-negated'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'allergy'
        
          
          @children['name'] = {:name => 'name', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['name'][:value] = HealthVault::WCData::Thing::Types::Codablevalue.new
            
          
        
          
          @children['reaction'] = {:name => 'reaction', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['first-observed'] = {:name => 'first-observed', :class => HealthVault::WCData::Dates::Approxdatetime, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['allergen-type'] = {:name => 'allergen-type', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
          
          @children['allergen-code'] = {:name => 'allergen-code', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['treatment-provider'] = {:name => 'treatment-provider', :class => HealthVault::WCData::Thing::Types::Person, :value => nil, :min => 0, :max => 1, :order => 6, :place => :element, :choice => 0 }
            
          
        
          
          @children['treatment'] = {:name => 'treatment', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 7, :place => :element, :choice => 0 }
            
          
        
          
          @children['is-negated'] = {:name => 'is-negated', :class => String, :value => nil, :min => 0, :max => 1, :order => 8, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
