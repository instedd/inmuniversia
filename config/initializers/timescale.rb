# Accelerates time based on 'time' setting
factor = ($DELAYED_JOB ? Settings.time.delayed_job_scale_factor : Settings.time.global_scale_factor) || 1
Timecop.scale(factor) if factor != 1