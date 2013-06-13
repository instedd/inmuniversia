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

class ChildrenController < AuthenticatedController

  respond_to :js

  def create
    @child = current_subscriber.children.new(params[:child])
    @active_tab = current_subscriber.preferences.fetch('dashboard.active_tab', 'calendars')
    @child.setup! if @child.save
  end

  def destroy
    @child = Child.find(params[:id])
    if @child.destroy
      redirect_to root_path
    else
      render :js => "alert('Hubo un error desuscribiendo a #{@child.name}');"
    end
  end

  protected

  def load_children
    @children = current_subscriber.children
  end

  def load_child
    @child = current_subscriber.children.find(params[:id])
  end

end
