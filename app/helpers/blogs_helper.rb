# frozen_string_literal: true

module BlogsHelper
  def format_content(blog)
    content = h(blog.content)
    simple_format(content)
  end
end
