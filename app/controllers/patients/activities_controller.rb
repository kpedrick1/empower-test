class Patients::ActivitiesController < Patients::ApplicationController

  layout "patients"
  include HealthVault


  def lalalala
    
    client = Restforce.new
    
    activity = params[:activity]
    
    query = "SELECT Id FROM Health_Activity__c 
            WHERE Date_AMPM__c = '#{activity[:Date_AMPM__c]}' 
            AND Date_Hour__c = '#{activity[:Date_Hour__c]}'
            AND Date_Minutes__c = '#{activity[:Date_Minutes__c]}'
            AND Date_Day__c = #{activity[:Date__c]} AND Account__c = '#{session[:account_id]}'"
    
    result = client.query(query)


    value = result.size    
    
    @instance_id = ""
    if result.size > 0
      @instance_id = result.first[:Id]
    end

    render json: @instance_id.to_json
  end

  def bloodpressure

    current_user = User.retrieve(session[:username])
    @hv_disconnected = false
    if current_user.nil?
      @hv_disconnected = true
    else
      if current_user.hv_recordid.nil?
        @hv_disconnected = true
      end

      puts 'hv_disconnected: ' + @hv_disconnected.to_s

      if @hv_disconnected == false
        app = Application.default
        connection = app.create_connection
        connection.authenticate

        offline_token = WCData::Request::OfflinePersonInfo.new
        offline_token.offline_person_id = current_user.hv_personid
        connection.user_auth_token = offline_token


        request = Request.create("GetThings", connection)
        request.header.record_id = current_user.hv_recordid

        request.info.add_group(WCData::Methods::GetThings::ThingRequestGroup.new)
        request.info.group[0].format = WCData::Methods::GetThings::ThingFormatSpec.new
        request.info.group[0].format.add_xml("")
        request.info.group[0].format.add_section("core")
        request.info.group[0].add_filter(WCData::Methods::GetThings::ThingFilterSpec.new)
        request.info.group[0].filter[0].add_type_id("ca3c57f4-f4c1-4e15-be67-0a3caf5414ed")

        result = request.send_offline

        bpArr = []

        if !result.info.group[0].thing.empty?

          thingArr = result.info.group[0].thing

          for i in 0..thingArr.length-1

            puts thingArr[i]

            y = nil
            m = nil
            d = nil
            if !thingArr[i].data_xml[0].anything.when.date.nil?
              y = thingArr[i].data_xml[0].anything.when.date.y
              m = thingArr[i].data_xml[0].anything.when.date.m
              d = thingArr[i].data_xml[0].anything.when.date.d
            end
            h = nil
            min = nil
            s = nil
            if !thingArr[i].data_xml[0].anything.when.time.nil?
              h = thingArr[i].data_xml[0].anything.when.time.h
              min = thingArr[i].data_xml[0].anything.when.time.m
              s = thingArr[i].data_xml[0].anything.when.time.s
            end
            systolic = thingArr[i].data_xml[0].anything.systolic
            diastolic = thingArr[i].data_xml[0].anything.diastolic
            pulse = thingArr[i].data_xml[0].anything.pulse
            irregular_heartbeat = thingArr[i].data_xml[0].anything.irregular_heartbeat
            thingId = thingArr[i].thing_id.data

            puts 'thing id'

            puts thingArr[i].data_xml[0].anything.irregular_heartbeat


            puts thingArr[i].thing_id.class

            puts thingArr[i].thing_id.data

            #puts thingArr[i].thing_id.thingkey


            bpArr.push({:year => y,
                        :month => m,
                        :day => d,
                        :hour => h,
                        :minute => min,
                        :sec => s,
                        :diastolic => diastolic,
                        :systolic => systolic,
                        :pulse => pulse,
                        :thingId => thingId,
                        :irregularHeartbeat => irregular_heartbeat
                       })

          end

          bpArr.each do |bph|
            puts bph
          end

          client = Restforce.new
          data_response = client.post "/services/apexrest/hvs/logs/", :accountId => session[:account_id], :bpList => bpArr

        end
      end
    end

    load_chart_data
    load_table_date
    load_times_salesforce
    authenticate_health_vault current_user

    bloodArr = []

    bloodArr.push(@systolic)
    bloodArr.push(@diastolic)

    render json: bloodArr.to_json

  end
  
  def new

    current_user = User.retrieve(session[:username])
    @hv_disconnected = false
    if current_user.nil?
      @hv_disconnected = true
    else
        if current_user.hv_recordid.nil?
          @hv_disconnected = true
        end

    end

    bp_values = (40..200).to_a
    @bp_values = bp_values.collect {|v| [v.to_s , v.to_s]}
    
    load_chart_data
    load_table_date
    load_times_salesforce
    authenticate_health_vault current_user
  end

  def sp_each(obj)
    s = ""
    obj.instance_variables.each do |v|
      s += "#{v}: #{obj.instance_variable_get(v)}\n"
    end
    s
  end

  def create
    
    overwrite = params[:overwrite]
    
    if overwrite == "false"
    
      activity = params[:activity]
      activity = activity.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} 

      activity[:Date__c] = normalize_date activity

      client = Restforce.new

      if client.create "Health_Activity__c", activity

        flash[:notice] = "Blood Pressure saved!"  
      else

        flash[:danger] = "Something went wrong. Please review data"
      end
      
    else 
      
      activity = params[:activity]
      activity = activity.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo} 

      activity[:Date__c] = normalize_date activity
      activity[:Id] = params["instance-id"]
      
      
      client = Restforce.new

      if client.update "Health_Activity__c", activity

        flash[:notice] = "Blood Pressure Updated!"  
      else

        flash[:danger] = "Something went wrong. Please review data"
      end      
      
      
    end
    
    redirect_to new_patients_activity_path
  end
  
  
  def load_table_date
    
    @activities = Hash.new
    account_id = session[:account_id]
    
    client = Restforce.new
    @activities = client.query("SELECT 
                                  Id, 
                                  Name, 
                                  Date__c, 
                                  Formatted_Date__c, 
                                  CreatedDate, 
                                  Blood_Pressure_Diastolic__c, 
                                  Blood_Pressure_Systolic__c,
                                  Date_Hour__c,
                                  Date_Minutes__c,
                                  Date_AMPM__c
                                FROM Health_Activity__c
                                WHERE Account__c = '#{account_id}'
                                AND Date__c != NULL
                                ORDER BY Date__c DESC
                                LIMIT 10")  
  end
  
  def load_chart_data
    account_id = session[:account_id]
    
    client = Restforce.new
    begin
      data_response = client.get "/services/apexrest/hvs/logs/#{account_id}"
      @systolic = data_response.body.systolic
      @diastolic = data_response.body.diastolic
    rescue
      @systolic = 0
      @diastolic = 0
    end


  end  
    
  def connect_to_health_vault
    redirect_to ENV['HVAUTHURL']
  end

  def disconnect_from_health_vault
    current_user = User.retrieve(session[:username])
    current_user.hv_recordid = nil
    current_user.hv_personid = nil
    current_user.save
    redirect_to '/patients/activities/new'
  end

  def authenticate_health_vault current_user
    if current_user.nil?
      return
    end
    is_connection_success = params[:target]

    if is_connection_success == "AppAuthSuccess"
      begin
        app = Application.default
        connection = app.create_connection
        connection.authenticate
      rescue Exception => e
        flash.now[:warning]= 'Connection with Health Vault could not be established'
        redirect_to 'patients/activities/new'
      end

      if params[:wctoken].nil?
        flash.now[:danger]= 'Authentication failed, please try again'
        return
      end

      begin
        request = Request.create("GetPersonInfo", connection)
        result = request.send
        puts result.info.person_info.to_s
        current_user.hv_recordid = result.info.person_info.selected_record_id
        current_user.hv_personid = result.info.person_info.person_id
        current_user.save
        flash.now[:notice]= 'Connection to Health Vault Established'
      rescue Exception => e
        flash.now[:warning]= 'Connection with Health Vault Not Established'
        puts e.to_s
      end

      redirect_to '/patients/activities/new'
    end
  end

  def load_times_salesforce
    
    client = Restforce.new
    
    @hours = client.picklist_values("Health_Activity__c", "Date_Hour__c").map{|x| x.value}
    @minutes = client.picklist_values("Health_Activity__c", "Date_Minutes__c").map{|x| x.value}
    
  end

  def normalize_date activity
    
    date = activity[:Date__c]
    
    apm = activity[:Date_AMPM__c] 
    hour = activity[:Date_Hour__c].to_i
    minutes = activity[:Date_Minutes__c]
    
    if apm == "PM"
        
        if hour != 12
          hour += 12
        end
      
    else
        if hour == 12
          hour += 12
        end      
    end
    
    date = date + "T#{hour % 24}:#{minutes}:00"
    
  end
  
  
end
