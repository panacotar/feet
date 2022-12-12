require 'erubis'

class View
  def initialize(controller_name, view_name, locals)
    @controller_name = controller_name
    @view_name = view_name
    @locals = locals
  end

  def call
    filename = File.join 'app', 'views', @controller_name, "#{@view_name}.html.erb"
    template = File.read filename
    eruby = Erubis::Eruby.new(template)
    eruby.result @locals
  end
end
