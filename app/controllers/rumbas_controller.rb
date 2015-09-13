class RumbasController < ApplicationController
  soap_service namespace: 'http://soap.sforce.com/2005/09/outbound'

  soap_action "notifications",
              :args   =>       {"notifications" =>
                                    {"OrganizationId" => :string,
                                     "ActionId" => :string,
                                     "SessionId" => :string,
                                     "EnterpriseUrl" => :string,
                                     "PartnerUrl" => :string,
                                     "Notification"=>
                                         {"Id" => :string,
                                          "sObject" =>
                                              {"sf:Id" => :string,
                                               "sf:Account__c" => :string,
                                               "sf:Email__c" => :string,
                                               "sf:Is_Active__c" => :boolean,
                                               "sf:Password__c" => :string,
                                               "sf:Send_Email__c" => :boolean,
                                               "sf:Username__c" => :string
                                              }
                                         }
                                    }
                                },
              :return => {"Ack" => :boolean},
              :to => :my_notifications,
              :response_tag => "notificationsResponse"

  def my_notifications

    #begin

      request.raw_post

      requestbody = request.body.read

      parser = Nori.new
      myhash = parser.parse(requestbody)

      portal_credential_id = myhash['soapenv:Envelope']['soapenv:Body']['notifications']['Notification']['sObject']['sf:Id']
      portal_credential_approved = myhash['soapenv:Envelope']['soapenv:Body']['notifications']['Notification']['sObject']['sf:Approved__c']

      # get the portal credential by the id and update the approved field
      user_record = User.where("portal_credential_id = ?", portal_credential_id).first


      if !user_record.blank?
        if portal_credential_approved != user_record.approved
          user_record.update(approved: portal_credential_approved)
        end
      end

    #rescue Exception

    #end

    render :soap => {"Ack" => true}

  end

end