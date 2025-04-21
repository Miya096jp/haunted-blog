# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    sanitized_content = h(blog.content)
    simple_format(sanitized_content)
  end
end
