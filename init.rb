require 'redmine'
require File.dirname(__FILE__) + "/lib/wiki_issue_fields"

Redmine::Plugin.register :redmine_wiki_issue_fields do
  name 'Redmine Wiki Issue fields plugin'
  author 'Stephane Briand'
  description 'This plugin adds a wiki macro to make it easier to list the details of issues on a wiki page.'
  url "http://www.seasidetech.net"
  version '0.5.7'
  requires_redmine :version_or_higher => '3.0.0'
  
end
