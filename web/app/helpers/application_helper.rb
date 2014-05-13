module ApplicationHelper

  def full_title(page_title)
    base_title = "PlayolaRadio 1.0"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def time_formatter(time)
    time.strftime("%b %e, %l:%M:%S %p")
  end
end
