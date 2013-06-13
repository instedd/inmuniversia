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

require 'csv'

class SubscriberAndChildImporter

  def import! file_name
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, :headers => true)
    count = 0
    vaccines = Vaccine.where("name = ? OR name = ?", "Cuadruple DTP-Hib", "Sabin (OPV)")
    csv.each do |row|
      params = Hash[row.map {|k,v| [k.strip.downcase.gsub(/ /, '_'),v]}]
      name = params["observaciones"].gsub(/[^a-zA-Z ]/,'').gsub(/ +/,' ')
      number = params["observaciones"].scan(/\d/).join

      subscriber = Subscriber.create_sms_subscriber number
      subscriber.first_name = name.downcase.capitalize
      child = subscriber.children.build(:name => params["nombre"].downcase.capitalize, :date_of_birth => params["fecha_nac"], :gender => (params["sexo"] == "M" ? "male" : "female"))
      child.subscribe!
      child.create_vaccinations!(vaccines)
      subscriber.save
      count +=1
    end
    count
  end
end