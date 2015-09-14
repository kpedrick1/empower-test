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
  
      class Testresultrange < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The type of the range.
#<b>preferred-vocabulary</b>: Contact the HealthVault team to help define this vocabulary.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def type=(value)
          @children['type'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def type
          return @children['type'][:value]
        end
       
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The range expressed as text.
#<b>remarks</b>: The text element is used in two different ways: When a numeric range is used, the text element should contain a textual version of the numeric range. When the range is non-numeric, the text element contains the range and the range value is omitted. The range may also be coded to a vocabulary. Examples: A color range (such as clear to yellow) would be coded using by setting the text element to "clear to yellow", and by assigning a code from an appropriate vocabulary. A numeric range (such as 0.5 - 1.6) would be stored in the minimum and maximum elements of the value, and additionally would be coded by setting the text element to "0.5 - 1.6".
#<b>preferred-vocabulary</b>: Contact the HealthVault team to help define this vocabulary.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def text=(value)
          @children['text'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def text
          return @children['text'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The minimum and maximum of the range.
#<b>remarks</b>: The minimum or maximum value may be omitted to specify open-ended ranges. Example: The range "greater than 3.5" would be coded by setting the minimum to 3.5 and omitting the maximum.
#<em>value</em> is a HealthVault::WCData::Thing::Labtestresults::Testresultrangevalue
        def value=(value)
          @children['value'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Labtestresults::Testresultrangevalue
        def value
          return @children['value'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'test-result-range'
        
          
          @children['type'] = {:name => 'type', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['type'][:value] = HealthVault::WCData::Thing::Types::Codablevalue.new
            
          
        
          
          @children['text'] = {:name => 'text', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 1, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          @children['text'][:value] = HealthVault::WCData::Thing::Types::Codablevalue.new
            
          
        
          
          @children['value'] = {:name => 'value', :class => HealthVault::WCData::Thing::Labtestresults::Testresultrangevalue, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
