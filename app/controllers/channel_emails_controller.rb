# Copyright (C) 2013, InSTEDD
#
# This file is part of Inmuniversia.
#
# Inmuniversia is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Inmuniversia is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Inmuniversia.  If not, see <http://www.gnu.org/licenses/>.

class ChannelEmailsController < AuthenticatedController

  before_filter :load_channel, only: [:update, :destroy]

  def create
    @channel = current_subscriber.email_channels.new(params[:channel_email])
    @channel.save
    render @channel
  end

  def update
    @channel.update_attributes(params[:channel_email])
    render @channel
  end

  def destroy
    @channel.destroy
    render nothing: true
  end

  protected

  def load_channel
    @channel = current_subscriber.email_channels.find(params[:id])
  end

end
