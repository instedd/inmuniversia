class AuthenticatedController < ApplicationController
  before_filter :authenticate_subscriber!
end