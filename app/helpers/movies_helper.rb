module MoviesHelper
    def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "hilite" : nil      
    link_to title, {:sort => column}, {:class => css_class}
    end
  
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
end
