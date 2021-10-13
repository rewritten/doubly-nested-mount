class HomeController < ApplicationController
  def index
    h =  request.headers.to_h.select { |k,v|
      ['HTTP','CONTENT','REMOTE','REQUEST','AUTHORIZATION','SCRIPT','SERVER'].any? { |s|
        k.to_s.starts_with? s
      }
    }.to_h


    Rails.logger.info h.inspect
  end
end
