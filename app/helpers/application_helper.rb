# frozen_string_literal: true

module ApplicationHelper

  def full_title(title = '')
    title << ' | ' unless title.empty?
    title + 'Simple Chess'
  end
end
