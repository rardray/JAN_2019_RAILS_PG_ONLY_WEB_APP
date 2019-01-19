class ApplicationController < ActionController::Base
    protect_forgery with: :exception

    def hello
        render html: "hello world"
    end
end
