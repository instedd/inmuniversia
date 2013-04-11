if Rails.env.development?
  factor = Settings.time.scale_factor || 1
  Timecop.scale(factor) if factor != 1
end