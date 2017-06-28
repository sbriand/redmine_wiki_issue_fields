class WifController < ApplicationController
  unloadable
  helper :issues
  include IssuesHelper
  include ActionView::Helpers::TagHelper




end
