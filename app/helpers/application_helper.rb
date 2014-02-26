module ApplicationHelper

  def global_path path_helper, engine = nil
    if engine
      engine::Engine.routes.url_helpers.send(path_helper)
    else
      Rails.application.routes.url_helpers.send(path_helper)
    end
  end

end
