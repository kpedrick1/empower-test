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
  module Vitalsigns
  
      class Vitalsignresulttype < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: Clinical name for vital sign.
#<b>preferred-vocabulary</b>: vital-statistics
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def title=(value)
          @children['title'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def title
          return @children['title'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Result value.
#<em>value</em> is a String
        def value=(value)
          @children['value'][:value] = value
        end
        
        #<b>returns</b>: a String
        def value
          return @children['value'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Result value unit.
#<b>preferred-vocabulary</b>: lab-results-units
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def unit=(value)
          @children['unit'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def unit
          return @children['unit'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Reference minimum value.
#<em>value</em> is a String
        def reference_minimum=(value)
          @children['reference-minimum'][:value] = value
        end
        
        #<b>returns</b>: a String
        def reference_minimum
          return @children['reference-minimum'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Reference maximum value.
#<em>value</em> is a String
        def reference_maximum=(value)
          @children['reference-maximum'][:value] = value
        end
        
        #<b>returns</b>: a String
        def reference_maximum
          return @children['reference-maximum'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Free form textual content of result.
#<em>value</em> is a String
        def text_value=(value)
          @children['text-value'][:value] = value
        end
        
        #<b>returns</b>: a String
        def text_value
          return @children['text-value'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Flag for result.
#<b>preferred-vocabulary</b>: lab-results-flag
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def flag=(value)
          @children['flag'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def flag
          return @children['flag'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'vital-sign-result-type'
        
          
          @children['title'] = {:name => 'title', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['title'][:value] = HealthVault::WCData::Thing::Types::Codablevalue.new
            
          
        
          
          @children['value'] = {:name => 'value', :class => String, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['unit'] = {:name => 'unit', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['reference-minimum'] = {:name => 'reference-minimum', :class => String, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
          
          @children['reference-maximum'] = {:name => 'reference-maximum', :class => String, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['text-value'] = {:name => 'text-value', :class => String, :value => nil, :min => 0, :max => 1, :order => 6, :place => :element, :choice => 0 }
            
          
        
          
          @children['flag'] = {:name => 'flag', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 7, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
