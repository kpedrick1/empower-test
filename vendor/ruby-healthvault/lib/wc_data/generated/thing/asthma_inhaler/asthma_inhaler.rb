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
  module AsthmaInhaler
  
      class Asthmainhaler < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The name of the drug in the canister.
#<b>remarks</b>: For example, 'ventolin' or 'albuterol'.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def drug=(value)
          @children['drug'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def drug
          return @children['drug'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The textual description of the drug strength.
#<b>remarks</b>: For example, '44 mcg / puff'.
#<em>value</em> is a HealthVault::WCData::Thing::Types::Codablevalue
        def strength=(value)
          @children['strength'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Types::Codablevalue
        def strength
          return @children['strength'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The purpose for the inhaler.
#<em>value</em> is a HealthVault::WCData::Thing::Inhaler::Purpose
        def purpose=(value)
          @children['purpose'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Thing::Inhaler::Purpose
        def purpose
          return @children['purpose'][:value]
        end
       
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The approximate date of when the inhaler started being used.
#<em>value</em> is a HealthVault::WCData::Dates::Approxdatetime
        def start_date=(value)
          @children['start-date'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Approxdatetime
        def start_date
          return @children['start-date'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The approximate date of when the inhaler was retired.
#<b>remarks</b>: Absence of this element implied that as far as we know the canister is still in use.
#<em>value</em> is a HealthVault::WCData::Dates::Approxdatetime
        def stop_date=(value)
          @children['stop-date'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Approxdatetime
        def stop_date
          return @children['stop-date'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The date the canister is clinically expired.
#<em>value</em> is a HealthVault::WCData::Dates::Approxdatetime
        def expiration_date=(value)
          @children['expiration-date'][:value] = value
        end
        
        #<b>returns</b>: a HealthVault::WCData::Dates::Approxdatetime
        def expiration_date
          return @children['expiration-date'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The unique id or serial number for the canister.
#<b>remarks</b>: If available, this value can be used to correlate uses.
#<em>value</em> is a String
        def device_id=(value)
          @children['device-id'][:value] = value
        end
        
        #<b>returns</b>: a String
        def device_id
          return @children['device-id'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The number of doses in the unit at the time the thing instance was created.
#<b>remarks</b>: This may not be the number the canister started with since the expectation is that a change in regimen will cause a new thing to be created as well.
#<em>value</em> is a String
        def initial_doses=(value)
          @children['initial-doses'][:value] = value
        end
        
        #<b>returns</b>: a String
        def initial_doses
          return @children['initial-doses'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The minimum number of doses that should be taken per day.
#<b>remarks</b>: A dose is one puff.
#<em>value</em> is a String
        def min_daily_doses=(value)
          @children['min-daily-doses'][:value] = value
        end
        
        #<b>returns</b>: a String
        def min_daily_doses
          return @children['min-daily-doses'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: The maximum number of doses that should be taken per day.
#<b>remarks</b>: A dose is one puff.
#<em>value</em> is a String
        def max_daily_doses=(value)
          @children['max-daily-doses'][:value] = value
        end
        
        #<b>returns</b>: a String
        def max_daily_doses
          return @children['max-daily-doses'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: States whether the inhaler can show alerts.
#<em>value</em> is a String
        def can_alert=(value)
          @children['can-alert'][:value] = value
        end
        
        #<b>returns</b>: a String
        def can_alert
          return @children['can-alert'][:value]
        end
       
     
        
        
       
        #<em>value</em> is a HealthVault::WCData::Thing::Inhaler::Alert
        def add_alert(value)
          @children['alert'][:value] << value
        end
        
        #<em>value</em> is a #HealthVault::WCData::Thing::Inhaler::Alert
        def remove_alert(value)
            @children['alert'][:value].delete(value)
        end
        
        
        #<b>summary</b>: A set of the alert times that the device should activate its feature.
#<b>remarks</b>: Note that his information can change without requiring a new thing to be created. The device data is the key for alerts, we just keep it here for display purposes.
#<b>returns</b>: a HealthVault::WCData::Thing::Inhaler::Alert Array
        def alert
          return @children['alert'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'asthma-inhaler'
        
          
          @children['drug'] = {:name => 'drug', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['drug'][:value] = HealthVault::WCData::Thing::Types::Codablevalue.new
            
          
        
          
          @children['strength'] = {:name => 'strength', :class => HealthVault::WCData::Thing::Types::Codablevalue, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
          
          @children['purpose'] = {:name => 'purpose', :class => HealthVault::WCData::Thing::Inhaler::Purpose, :value => nil, :min => 0, :max => 1, :order => 3, :place => :element, :choice => 0 }
            
          
        
          
          @children['start-date'] = {:name => 'start-date', :class => HealthVault::WCData::Dates::Approxdatetime, :value => nil, :min => 1, :max => 1, :order => 4, :place => :element, :choice => 0 }
            
          @children['start-date'][:value] = HealthVault::WCData::Dates::Approxdatetime.new
            
          
        
          
          @children['stop-date'] = {:name => 'stop-date', :class => HealthVault::WCData::Dates::Approxdatetime, :value => nil, :min => 0, :max => 1, :order => 5, :place => :element, :choice => 0 }
            
          
        
          
          @children['expiration-date'] = {:name => 'expiration-date', :class => HealthVault::WCData::Dates::Approxdatetime, :value => nil, :min => 0, :max => 1, :order => 6, :place => :element, :choice => 0 }
            
          
        
          
          @children['device-id'] = {:name => 'device-id', :class => String, :value => nil, :min => 0, :max => 1, :order => 7, :place => :element, :choice => 0 }
            
          
        
          
          @children['initial-doses'] = {:name => 'initial-doses', :class => String, :value => nil, :min => 0, :max => 1, :order => 8, :place => :element, :choice => 0 }
            
          
        
          
          @children['min-daily-doses'] = {:name => 'min-daily-doses', :class => String, :value => nil, :min => 0, :max => 1, :order => 9, :place => :element, :choice => 0 }
            
          
        
          
          @children['max-daily-doses'] = {:name => 'max-daily-doses', :class => String, :value => nil, :min => 0, :max => 1, :order => 10, :place => :element, :choice => 0 }
            
          
        
          
          @children['can-alert'] = {:name => 'can-alert', :class => String, :value => nil, :min => 0, :max => 1, :order => 11, :place => :element, :choice => 0 }
            
          
        
          
          @children['alert'] = {:name => 'alert', :class => HealthVault::WCData::Thing::Inhaler::Alert, :value => Array.new, :min => 0, :max => 999999, :order => 12, :place => :element, :choice => 0 }
          
        
        end
      end
  end
  end
  
  end
end
