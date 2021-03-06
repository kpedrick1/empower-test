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
  module Pregnancy
  
      class Pregnancy < ComplexType
        
     
        
        
       
        
        #<b>summary</b>: The approximate due date.
#<em>value</em> is a HealthVault::WCData::Dates::Approxdate
        def due_date=(value)
          @children['due-date'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Approxdate
        def due_date
          return @children['due-date'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The first day of the last menstrual cycle.
#<em>value</em> is a HealthVault::WCData::Dates::Date
        def last_menstrual_period=(value)
          @children['last-menstrual-period'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Date
        def last_menstrual_period
          return @children['last-menstrual-period'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The method of conception.
#<b>preferred-vocabulary</b>: conception-methods
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def conception_method=(value)
          @children['conception-method'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def conception_method
          return @children['conception-method'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The number of fetuses.
#<em>value</em> is a String
        def fetus_count=(value)
          @children['fetus-count'][:value] = value
        end
        
        #<b>returns</b>: a String
        def fetus_count
          return @children['fetus-count'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Number of weeks of pregnancy at the time of delivery.
#<em>value</em> is a String
        def gestational_age=(value)
          @children['gestational-age'][:value] = value
        end
        
        #<b>returns</b>: a String
        def gestational_age
          return @children['gestational-age'][:value]
        end
       
     
        
        
       
        #<em>value</em> is a HealthVault::WCData::Thing::Pregnancy::Delivery
        def add_delivery(value)
          @children['delivery'][:value] << value
        end
        
        #<em>value</em> is a #HealthVault::WCData::Thing::Pregnancy::Delivery
        def remove_delivery(value)
            @children['delivery'][:value].delete(value)
        end
        
        
        #<b>summary</b>: Details about the resolution for each fetus.
#<b>returns</b>: a HealthVault::WCData::Thing::Pregnancy::Delivery Array
        def delivery
          return @children['delivery'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'pregnancy'
        
          
          @children['due-date'] = {:name => 'due-date', :class => HealthVault::WCData::Dates::Approxdate, :value => nil, :min => 0, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          
        
          
          @children['last-menstrual-period'] = {:name => 'last-menstrual-period', :class => HealthVault::WCData::Dates::Date, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['conception-method'] = {:name => 'conception-method', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['fetus-count'] = {:name => 'fetus-count', :class => String, :value => nil, :min => 0, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          
        
          
          @children['gestational-age'] = {:name => 'gestational-age', :class => String, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['delivery'] = {:name => 'delivery', :class => HealthVault::WCData::Thing::Pregnancy::Delivery, :value => Array.new, :min => 0, :max => 999999, :order => 6, :place => :element, :choice => 0 }
          
        
        end
      end
  end
  end
  
  end
end
