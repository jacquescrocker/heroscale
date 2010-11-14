module Heroscale
  class Railtie < ::Rails::Railtie
    initializer "heroscale.add_middleware" do |app|
      app.config.middleware.use "Heroscale::Middleware"
    end
  end
end