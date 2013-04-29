class BootstrapFormBuilder < ActionView::Helpers::FormBuilder

  delegate :content_tag, :tag, :safe_join, to: :@template

  OverridenControls = %w[text_field text_area password_field collection_select select]

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
