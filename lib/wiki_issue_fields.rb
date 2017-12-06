require 'redmine'
require 'application_helper'
require 'issues_helper'

module WikiIssueFieldsMacro

  ##############################################################################

  Redmine::WikiFormatting::Macros.register do
    error_message = "Display a list of issues and some of their properties in a wiki page. The text is click-able, making a link to the issue itself.\n\n" +
         "+Syntax:+\n" +
         "<pre>Single issue : {{issue_fields(issue_id,[options],[arguments])}}\n\n" +
         "List of issues : {{issue_fields(issue_id_1 issue_id_2,[options],[arguments])}}</pre>\n\n" +
         "_issue_id_ : issue number\n" +
         "+Options:+\n" +
         "* +l : Add html link\n" +
         "* +p : display the project name number\n" +
         "* +i : display the issue number\n" +
         "* +c : display the field caption of any field after this option\n" +
	       "* +s : specify a separator to be used instead of coma\n\n" +
         "+Arguments:+\n" +
         "* Natives issue field : project, tracker, parent, children, status, priority, subject, author, assigned_to, updated_on, \n" +
         "                        category, fixed_version, start_date, due_date, estimated_hours, done_ratio, created, relations\n" +
         "* Custom issue fields name\n\n" +
         "+Examples:+\n" +
         "<pre>{{issue_fields(1,subject)}} ->  This is the subject of the issue number 1\n" +
         "{{issue_fields(2,+c,subject)}} ->  Subject : This is the subject of the issue number 2\n" +
         "{{issue_fields(3,+p,+i,subject)}} ->  test - #3, This is the subject of the issue number 3\n" +
         "{{issue_fields(1 2 3,subject)}} -> This is the subject of the issue number 1\n" +
         "                                   This is the subject of the issue number 2\n" +
         "                                   This is the subject of the issue number 3</pre>"

    desc error_message
               
    macro :issue_fields do |obj, args|
    
  ##############################################################################
    
      return textilizable(error_message) unless args.length > 0

      #issue_id = args[0].strip
      #issue = Issue.visible.find_by_id(issue_id)
      
      issues = Array.new
      issues = args[0].split.collect { |e| Issue.visible.find_by_id(e)}
      
      return textilizable("%{background-color:yellow}Issues missing%") if issues.empty?
      
      ##########################################################################
      
      html_link = true
      display_fields_caption = 0
      display_project_name = 0
      display_issue_id = 0
      separator = ", "
      output_html = ''.html_safe
      relation_div = ''.html_safe

      issues.each do |issue|
        return textilizable("%{background-color:yellow}Invalid issue ID%") if issue.nil?
        response = ''.html_safe
        description = ''.html_safe
        compteur_args = 1
        while (compteur_args < args.length)
            entre = args[compteur_args].strip
            
            if args[compteur_args].strip == "-l"
                html_link = false
            end

            if args[compteur_args].strip == "+l"
              html_link = true
            end
  
            if args[compteur_args].strip == "+p"
                display_project_name = 1
            end
  
            if args[compteur_args].strip == "+i"
                display_issue_id = 1
            end
  
            if args[compteur_args].strip == "+c"
                display_fields_caption = 1
            end

            if args[compteur_args].strip == "-c"
              display_fields_caption = 0
            end
  
            if args[compteur_args].strip == "-s"
                separator = ""
            end
  
            if args[compteur_args].strip == "+s"
                separator = ", "
            end
  
            if args[compteur_args].strip == "+ss"
                separator = " "
            end
  
            if args[compteur_args].strip == "+s-"
                separator = "-"
            end
  
            sortie = ''.html_safe
            sortie_name = separator.html_safe
  
           
            ######################################################################
            if entre == "created"   ### 1 ###
               sortie_name << "Created: "
               
               if issue.created_on != nil
               
                   day = h(issue.created_on.day).to_s
                   if ( day.length < 2 )
                       day = '0' + day
                   end
  
                   month = h(issue.created_on.month).to_s
                   if ( month.length < 2 )
                       month = '0' + month
                   end
               
                   year = h(issue.created_on.year).to_s
               
                   hour = h(issue.created_on.hour).to_s
                   if ( hour.length < 2 )
                       hour = '0' + hour
                   end
               
                   min = h(issue.created_on.min).to_s
                   if ( min.length < 2 )
                       min = '0' + min
                   end
               
                   sec = h(issue.created_on.sec).to_s
                   if ( sec.length < 2 )
                       sec = '0' + sec
                   end
                   
                   sortie << day + "/" + month + "/" + year + " - " + hour + ":" + min + ":" + sec
               
               end
            end
            
            if entre == "tracker"
               sortie_name << "Tracker: "
               sortie << h(issue.tracker)
            end    
            
            if entre == "author"   ### 2 ###
               sortie_name << "Author: "
               sortie << h(issue.author)
            end    
            
            if entre == "subject"   ### 3 ###
               sortie_name << "Subject: "
               sortie << h(issue.subject)
            end
            
            if entre == "description"   ### 3 ###
               description << content_tag('div', textilizable(issue, :description), :class => "description")
            end
            
            if entre == "status"   ### 4 ###
               sortie_name << "Status: "
               sortie << h(issue.status)
            end          
            
            if entre == "priority"   ### 5 ###
               sortie_name << "Priority: "
               sortie << h(issue.priority)
            end          
            
            if entre == "assigned_to"   ### 6 ###
               sortie_name << "Assigned to: "
               sortie << h(issue.assigned_to)
            end
            
            if entre == "category"   ### 7 ###
               sortie_name << "Category: "
               sortie << h(issue.category)
            end           
  
            if entre == "target_version"   ### 8 ###
               sortie_name << "Target Version: "
               sortie << h(issue.target_version)
            end 
  
            if entre == "duration"   ### 9 ###
               sortie_name << "Duration: "
               sortie << h(issue.duration)
            end
            
            if entre == "start_date"   ### 10 ###
               sortie_name << "Start Date: "
               
               if issue.start_date != nil
               
                   day = h(issue.start_date.day).to_s
                   if ( day.length < 2 )
                       day = '0' + day
                   end
               
                   month = h(issue.start_date.month).to_s
                   if ( month.length < 2 )
                       month = '0' + month
                   end
               
                   year = h(issue.start_date.year).to_s
                   
                   sortie << day + "/" + month + "/" + year
               
               end
            end
            
            if entre == "due_date"   ### 11 ###
               sortie_name << "Due Date: "
               
               if issue.due_date != nil
               
                   day = h(issue.due_date.day).to_s
                   if ( day.length < 2 )
                       day = '0' + day
                   end
               
                   month = h(issue.due_date.month).to_s
                   if ( month.length < 2 )
                       month = '0' + month
                   end
               
                   year = h(issue.due_date.year).to_s
                   
                   sortie << day + "/" + month + "/" + year
  
               end
  
            end          
            
            if entre == "%_done"   ### 12 ###
               sortie_name << "Done: "
               sortie << h(issue.done_ratio)
            end 
            
            if entre == "spent_time"   ### 13 ###
               sortie_name << "Spent Time: "
               sortie << h(issue.spent_hours)
            end           
  
            if entre == "estimated_time"   ### 14 ###
               sortie_name << "Estimated Time: "
               sortie << h(issue.estimated_hours)
            end       
  
            if entre == "parent"   ### 15 ###
               sortie_name << "Parent: "
               sortie << h(issue.parent)
            end
            
            if entre == "updated"   ### 16 ###
               sortie_name << "Updated On: "
               
               if issue.updated_on != nil
               
                   day = h(issue.updated_on.day).to_s
                   if ( day.length < 2 )
                       day = '0' + day
                   end
               
                   month = h(issue.updated_on.month).to_s
                   if ( month.length < 2 )
                       month = '0' + month
                   end
               
                   year = h(issue.updated_on.year).to_s
                   
                   sortie << day + "/" + month + "/" + year
               end
            end

            if entre == "relations" ## 17 ##
              @relations = issue.relations
              @issue = issue
              relation_div << render(:partial => 'relations').html_safe
            end

            if entre == "children"   ### 18 ###

              relation_div << render(:partial => 'descendants_tree', :locals => {:issue => issue}).html_safe
            end

            ######################################################################
            # Manage the custom fields
            ######################################################################
   
            if sortie == "" && sortie_name == separator.html_safe
                           
               issue.custom_field_values.each do |c|
                 if entre == c.custom_field.name
                     sortie_name << c.custom_field.name + ": "
                     if c.custom_field.field_format == "list"  && c.custom_field.multiple?
                         sortie << c.value.join(separator)
                     elsif c.custom_field.field_format == "user"
                       if c.custom_field.multiple?
                         c.value.each do  |value|
                           sortie <<  issue.project.users.find_by_id(value.to_i).name + separator
                         end
                       else
                         sortie <<  issue.project.users.find_by_id(c.value.to_i).name
                       end
                     elsif c.custom_field.field_format == "bool"
                         if c.value == "1"
                             sortie << "Yes"
                         else
                             sortie << "No"
                         end
                     elsif c.custom_field.field_format == "enumeration"
                       sortie << CustomFieldEnumeration.find_by_id(c.value).name
                     elsif c.custom_field.field_format == "text"
                       sortie << textilizable(c.value)
                     else
                         sortie << c.value
                     end
                 end
               end
            end # end if
  
              
            ######################################################################
            #
            ######################################################################
            if ["-p", "-i", "-c", "-C", "-S", "-N", "-P", "+i", "+c", "+p", "-s", "+s", "+ss", "+s-"].include?args[compteur_args].strip
  
               sortie_name = ''.html_safe 
               sortie = ''.html_safe 
  
            elsif args[compteur_args-1].strip == "-c" || display_fields_caption == 0
            
               sortie_name = separator.html_safe
               
            end
            
            response << sortie_name
            response << sortie
            
            compteur_args = compteur_args + 1
            
        end # while
  
        ##########################################################################
        ##########################################################################
        
        # Remove the first comma
        #if response[0..1] == separator.html_safe
        #  response = response[2..-1].html_safe
        #end
        #if response[0] == separator.html_safe
        #  response = response[1..-1].html_safe
        #end
        # remove comas, spaces and tabulation at begining of response strin 
        response = response.sub(/^[, \t]*/,"").html_safe
  
        if display_issue_id == 1
          issue_link = link_to("#" + issue.id.to_s + ", " , :controller => 'issues', :action => 'show', :id => issue.id)
        else
	        issue_link = h("")
        end

        if (html_link == true) 
          issue_link = issue_link + link_to(response, :controller => 'issues', :action => 'show', :id => issue.id) + relation_div
        else
          issue_link = issue_link + response + relation_div
        end
   
        if display_project_name == 1
           project_link = link_to(h(issue.project), :controller => 'projects', :action => 'show', :id => issue.project)
           output_html << project_link + " - " + issue_link
        else
           output_html << issue_link
        end
        output_html << "<br/>".html_safe + description unless description.to_s == ""
        unless issues.count == 1
          output_html << "<br/>".html_safe + "\r\n"
        end
      end # each issues 
      output_html
    end # macro

    desc "Insert the modification date of a wiki page. Example:\n\n  !{{wiki_modification_date(Foo)}}\n\nor for a page of a specific project wiki:\n\n  !{{wiki_modification_date(projectname:Foo)}}"
      macro :wiki_modification_date do |obj, args|
        page = Wiki.find_page(args.first.to_s, :project => @project)
        raise 'Page not found' if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)
        #o = '<span class="wiki_extensions_lastupdated_at">'
        o =  format_time(page.updated_on)
        #o << '<br />'
        #o << '</span>'
        o.html_safe
      end # macro


  end # register


end # module

################################################################################
