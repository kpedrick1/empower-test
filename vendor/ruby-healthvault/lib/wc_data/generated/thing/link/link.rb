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
  module Link
  
      class Link < ComplexType
        
     
        
        
       
        #<b>REQUIRED</b>
        #<b>summary</b>: The full URL for the link, including the scheme and full site name.
#<em>value</em> is a String
        def url=(value)
          @children['url'][:value] = value
        end
        
        #<b>returns</b>: a String
        def url
          return @children['url'][:value]
        end
       
     
        
        
       
        
        #<b>summary</b>: Optional friendly name for the link.
#<em>value</em> is a String
        def title=(value)
          @children['title'][:value] = value
        end
        
        #<b>returns</b>: a String
        def title
          return @children['title'][:value]
        end
       
  
      
        def initialize
          super
          self.tag_name = 'link'
        
          
          @children['url'] = {:name => 'url', :class => String, :value => nil, :min => 1, :max => 1, :order => 1, :place => :element, :choice => 0 }
            
          @children['url'][:value] = String.new
            
          
        
          
          @children['title'] = {:name => 'title', :class => String, :value => nil, :min => 0, :max => 1, :order => 2, :place => :element, :choice => 0 }
            
          
        
        end
      end
  end
  end
  
  end
end
