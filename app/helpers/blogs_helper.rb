# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    escaped_content = h(blog.content)
    simple_format(escaped_content)
  end
end
