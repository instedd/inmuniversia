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

class BootstrapFormBuilder < ActionView::Helpers::FormBuilder

  delegate :content_tag, :tag, :safe_join, to: :@template

  OverridenControls = %w[email_field text_field text_area password_field collection_select select]

  OverridenControls.each do |method_name|
    define_method(method_name) do |name, *args|
      has_errors = object.errors[name].any?
      options = args.extract_options!

      klazz = "control-group"
      klazz << " error" if has_errors

      error_msg =   has_errors ? content_tag(:span, error_message_on(name), class: 'help-inline') : ""
      label_tag =   options[:label] ? label(name, options[:label], class: "control-label") : ""
      control_tag = content_tag(:div, class: 'control') { super(name, *args << options) }

      content_tag :div, class: klazz do
        safe_join([label_tag, control_tag, error_msg])
      end
    end
  end

  def actions(&block)
    content_tag :div, class: 'form-actions' do
      yield
    end
  end

end
